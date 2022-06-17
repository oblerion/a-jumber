local mygame = require("game")

mygame.Team.Add("tank",2,1,0)
mygame.Team.Add("soldat",6,3,1)

local cursor = {
	x = 0,
	y = 0,
	id_select=-1
}
function cursor_update(mygame,cursor)
	if(vthumb.buttonD.justPressed==true and 
		cursor.y<4
		)then 
		cursor.y = cursor.y + 1
	end
	if(vthumb.buttonU.justPressed==true and 
		cursor.y>0 
		)then 
		cursor.y = cursor.y - 1
	end
	if(vthumb.buttonR.justPressed==true and 
		cursor.x<8)then 
		cursor.x = cursor.x + 1
	end
	if(vthumb.buttonL.justPressed==true and 
		cursor.x>0 )then 
		cursor.x = cursor.x -1
	end
	if(vthumb.buttonA.justPressed==true)then
		if(cursor.id_select==-1)then
			cursor.id_select = mygame.Team.Get(cursor.x,cursor.y)
		else
			if(mygame.Team.Get(cursor.x,cursor.y)==-1)then
				mygame.Team.lstunitee[cursor.id_select].x = cursor.x
				mygame.Team.lstunitee[cursor.id_select].y = cursor.y
				cursor.id_select=-1
			end
		end
	end
	if(vthumb.buttonB.justPressed==true)then
		cursor.id_select=-1
	end
end
function cursor_draw(mygame,cursor)
	if(cursor.id_select==-1)then
		mygame.Tile.Draw(1+(cursor.x)*8,1+(cursor.y)*8,6)
	else
		mygame.Tile.Draw(1+(mygame.Team.lstunitee[cursor.id_select].x)*8,
			1+(mygame.Team.lstunitee[cursor.id_select].y)*8,6)
		mygame.Tile.Draw(1+(cursor.x)*8,1+(cursor.y)*8,7)
	end
end
local inter_unitee=0
function inter_unitee_update(mygame,cursor)
  if(vthumb.buttonA.justPressed==true and 
    mygame.Team.Get(cursor.x,cursor.y)==cursor.id_select and 
    inter_unitee==0)then
      inter_unitee=1
  elseif(inter_unitee==1 and 
    vthumb.buttonB.justPressed==true)then
    inter_unitee=0
  end
end
function inter_unitee_draw(mygame,cursor)
--  local lu = 
 -- print(type(lu.x))
  mygame.Font.Print("hp :"..mygame.Team.lstunitee[cursor.id_select].hp,8,8)
  mygame.Font.Print("mv :"..mygame.Team.lstunitee[cursor.id_select].mov,8,16)
  mygame.Font.Print("type :"..mygame.Team.lstunitee[cursor.id_select].name,8,24)
  mygame.Sprite.Draw16x16(46,8,mygame.Team.lstunitee[cursor.id_select].bid)
end
function game()
  inter_unitee_update(mygame,cursor)
  if(inter_unitee==0)then
    cursor_update(mygame,cursor)
    mygame.Team.Draw()
    cursor_draw(mygame,cursor)
    mygame.Map.Draw(1)
  else
    inter_unitee_draw(mygame,cursor)
  end
end