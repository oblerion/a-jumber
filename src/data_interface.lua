local mygame = require("game")

--~ mygame.Inter.Create(name,
--~ function end,
--~ function end)

mygame.Inter.Create("ititle",
function(mygame) 
    if( vthumb.buttonA.justPressed==true or 
        vthumb.buttonB.justPressed==true or 
        vthumb.buttonU.justPressed==true or 
        vthumb.buttonD.justPressed==true or 
        vthumb.buttonL.justPressed==true or
        vthumb.buttonR.justPressed==true)then
        mygame.Inter.Set("ituto")
    end
end,
function(mygame) 
	mygame.Font.Print("A-JUMBER",16,1)
	mygame.Font.Print("tactic fight",16,9)
	mygame.Map.DrawAt(1,4,mygame.Unitee.Get("VTM").id)
	mygame.Map.DrawAt(3,4,mygame.Unitee.Get("tank").id)
	mygame.Map.DrawAt(7,4,mygame.Unitee.Get("soldat",-1).id)
	mygame.Map.DrawAt(5,3,mygame.Unitee.Get("avion",-1).id)
end)


mygame.Inter.Create("ituto",
function() 
    if( vthumb.buttonA.justPressed==true or 
        vthumb.buttonB.justPressed==true or 
        vthumb.buttonU.justPressed==true or 
        vthumb.buttonD.justPressed==true or 
        vthumb.buttonL.justPressed==true or
        vthumb.buttonR.justPressed==true)then
        mygame.Inter.Set("imap")
    end
end,
function(mygame)
	mygame.Font.Print("    TUTORIAL",1,1)
	mygame.Font.Print("arrow for move",1,16)
	mygame.Font.Print("A for select,attack",1,24)
	mygame.Font.Print("B for back",1,32)
end)



mygame.Inter.Create("imap",
function(mygame)
	-- moving cursor
	if(vthumb.buttonD.justPressed==true and 
	mygame.Cursor.y<4
	)then 
		mygame.Cursor.y = mygame.Cursor.y + 1
	end
	if(vthumb.buttonU.justPressed==true and 
	mygame.Cursor.y>0 
	)then 
		mygame.Cursor.y = mygame.Cursor.y - 1
	end
	if(vthumb.buttonR.justPressed==true and 
	mygame.Cursor.x<8)then 
		mygame.Cursor.x = mygame.Cursor.x + 1
	end
	if(vthumb.buttonL.justPressed==true and 
		mygame.Cursor.x>0 )then 
		mygame.Cursor.x = mygame.Cursor.x -1
	end
	-- start inter unit
	if(vthumb.buttonA.justPressed==true and 
    mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y)==mygame.Cursor.id_select and 
    mygame.Cursor.id_select~=-1)then
		mygame.Inter.Set("iunitee")
    end
	-- select
	if(vthumb.buttonA.justPressed==true)then
		if(mygame.Cursor.id_select==-1)then
			mygame.Cursor.id_select = mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y)
		elseif(mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y)==-1 and 
			mygame.Map.Get(mygame.Cursor.x,mygame.Cursor.y,mygame.Map.curant_id)==0)then
			mygame.Team.Move(mygame.Cursor.id_select,mygame.Cursor.x,mygame.Cursor.y)
			mygame.Cursor.id_select=-1
		elseif(mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y)~=mygame.Cursor.id_select and 
			mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y)>-1)then
			mygame.Team.Atk(mygame.Cursor.id_select,mygame.Team.Get(mygame.Cursor.x,mygame.Cursor.y))
		end
	end
	-- annuler
	if(vthumb.buttonB.justPressed==true)then
		mygame.Cursor.id_select=-1
	end
end,
function(mygame)
	mygame.Team.Draw()
	-- cursor draw
	if(mygame.Cursor.id_select==-1)then
		mygame.Tile.Draw(1+(mygame.Cursor.x)*8,1+(mygame.Cursor.y)*8,6)
	else
		mygame.Tile.Draw(1+(mygame.Team.lstunitee[mygame.Cursor.id_select].x)*8,
			1+(mygame.Team.lstunitee[mygame.Cursor.id_select].y)*8,6)
		mygame.Tile.Draw(1+(mygame.Cursor.x)*8,1+(mygame.Cursor.y)*8,7)
	end
	mygame.Map.Draw()
end)


mygame.Inter.Create("iunitee",
function(mygame)
  if(vthumb.buttonB.justPressed==true)then
    mygame.Inter.Set("imap")
  end
end,
function(mygame)
	if(mygame.Cursor.id_select>-1)then
		mygame.Font.Print("TEAM :"..(mygame.Team.lstunitee[mygame.Cursor.id_select].team+1),8,8)
		mygame.Font.Print("HP :"..mygame.Team.lstunitee[mygame.Cursor.id_select].hp,8,16)
		mygame.Font.Print("MV :"..mygame.Team.lstunitee[mygame.Cursor.id_select].mov,8,24)
		mygame.Font.Print("TYPE :"..mygame.Team.lstunitee[mygame.Cursor.id_select].name,8,32)
		mygame.Sprite.Draw(50,16,mygame.Team.lstunitee[mygame.Cursor.id_select].id)
	end
end)


mygame.Inter.Create("ifight",
function(mygame) 

end,
function(mygame) 

end)




