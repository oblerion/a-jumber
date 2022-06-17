local mygame = require("game")

mygame.Team.Add("tank",2,1)
mygame.Team.Add("soldat",6,3,1)

local cursor = {
  x = 0,
  y = 0,
  id_select=-1
}
function cursor_update(mygame,cursor)
  -- moving cursor
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
  -- select
  if(vthumb.buttonA.justPressed==true)then
    if(cursor.id_select==-1)then
		cursor.id_select = mygame.Team.Get(cursor.x,cursor.y)
    elseif(mygame.Team.Get(cursor.x,cursor.y)==-1 and 
        mygame.Map.Get(cursor.x,cursor.y,mygame.Map.curant_id)==0)then
        mygame.Team.Move(cursor.id_select,cursor.x,cursor.y)
        cursor.id_select=-1
    elseif(mygame.Team.Get(cursor.x,cursor.y)~=cursor.id_select)then
		mygame.Team.Atk(cursor.id_select,mygame.Team.Get(cursor.x,cursor.y))
    end
  end
  -- annuler
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
    inter_unitee==0 and
    cursor.id_select~=-1)then
    inter_unitee=1
  elseif(inter_unitee==1 and 
    vthumb.buttonB.justPressed==true)then
    inter_unitee=0
  end
end
function inter_unitee_draw(mygame,cursor)
  if(type(mygame.Team.lstunitee[cursor.id_select])=="table")then
    mygame.Font.Print("TEAM :"..(mygame.Team.lstunitee[cursor.id_select].team+1),8,8)
    mygame.Font.Print("HP :"..mygame.Team.lstunitee[cursor.id_select].hp,8,16)
    mygame.Font.Print("MV :"..mygame.Team.lstunitee[cursor.id_select].mov,8,24)
    mygame.Font.Print("TYPE :"..mygame.Team.lstunitee[cursor.id_select].name,8,32)
    mygame.Sprite.Draw(50,16,mygame.Team.lstunitee[cursor.id_select].id)
  end
end
mygame.Map.SetCurantId(1)
function game()
  inter_unitee_update(mygame,cursor)
  if(inter_unitee==0)then
    cursor_update(mygame,cursor)
    mygame.Team.Draw()
    cursor_draw(mygame,cursor)
    mygame.Map.Draw()
  else
    inter_unitee_draw(mygame,cursor)
  end
end
