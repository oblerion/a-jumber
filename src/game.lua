--[[vthumb.display.width  : largeur de l’écran
vthumb.display.height : heuteur de l’écran
vthumb.buttonA.pressed / justPressed
vthumb.buttonB.pressed / justPressed
vthumb.buttonU.pressed / justPressed
vthumb.buttonD.pressed / justPressed
vthumb.buttonL.pressed / justPressed
vthumb.buttonR.pressed / justPressed
vthumb.setPixel(x,y)
pixel = vthumb.getPixel(x,y)
vthumb.Sprite(x,y,array)
--]]
function table.reverse(t)
  local lt = {}
  local i
  for i=#t, 1, -1 do
    lt[#lt+1] = t[i]
  end
  return lt
end
function getnumber(str)
  local i
  local nb=0
  for i=1,8 do
    if(str:sub(i,i)=="1")then
      nb = nb + math.ldexp(1,i-1)
    end
  end
  return nb
end
function getsprite(t,inv)
  local i
  local lt = {}
  local lstr
  if(inv==nil)then inv=0 end
  for i=1,#t do
    lstr = t[i]
    if(inv==0)then lstr=string.reverse(lstr) end
    table.insert(lt,getnumber(lstr))
  end
  return lt
end
------- game table -----
local g ={
  lsprite={},
  lsprite16x8={},
  lsprite16x16={},
  lsprite16x8_inv={},
  lsprite16x16_inv={}
}
------- sprite
g.Sprite={}
g.Sprite.Add=function(spr,inv)
  if(inv==nil)then inv=0 end
  if(#spr==8 and spr[1]:len()==8)then
    table.insert(g.lsprite,getsprite(spr,inv))
  elseif(#spr==8 and spr[1]:len()==16)then
    local i,j
    local lt={}
    local t={}
    local lstr
    for j=0,1 do
      for i=1,8 do
        --print(i,j,spr[i]:sub((8*j)+1,(8*j)+8))
        lstr = spr[i]:sub((8*j)+1,(8*j)+8)
        if(inv==0)then lstr=string.reverse(lstr)end
        table.insert(lt,getnumber(lstr))
      end
      table.insert(t,lt)
      lt={}
    end
    table.insert(g.lsprite16x8,t)
    table.insert(g.lsprite16x8_inv,inv)
  elseif(#spr==16 and spr[1]:len()==16)then
    --print("begin ",#g.lsprite16x16)
    local i,j,k
    local lt={}
    local t={}
    local lstr
    for k=0,1 do
      for j=0,1 do
        for i=1,8 do
          lstr = spr[(k*8)+i]:sub((8*j)+1,(8*j)+8)
          if(inv==0)then lstr = string.reverse(lstr) end
          table.insert(lt,getnumber(lstr))
        end
          table.insert(t,lt)
        lt={}
      end
    end
    table.insert(g.lsprite16x16,t)
    table.insert(g.lsprite16x16_inv,inv)
     --print("end ",#g.lsprite16x16)
  end
end
g.Sprite.Draw=function(x,y,id)
  if id <= #g.lsprite and id > 0 then 
    vthumb.Sprite(x,y,g.lsprite[id]) 
  else 
    print("g.Sprite.Draw() id "..id.." don t exist")
  end
end
g.Sprite.Draw16x8=function(x,y,id)
  vthumb.Sprite(x,y,g.lsprite16x8[id][1+g.lsprite16x8_inv[id]])
  vthumb.Sprite(x+8,y,g.lsprite16x8[id][2-g.lsprite16x8_inv[id]])
end
g.Sprite.Draw16x16=function(x,y,id)
  if(type(g.lsprite16x16[id])=="table")then
    vthumb.Sprite(x,y,g.lsprite16x16[id][1+g.lsprite16x16_inv[id]])
    vthumb.Sprite(x+8,y,g.lsprite16x16[id][2-g.lsprite16x16_inv[id]])
    vthumb.Sprite(x,y+8,g.lsprite16x16[id][3+g.lsprite16x16_inv[id]])
    vthumb.Sprite(x+8,y+8,g.lsprite16x16[id][4-g.lsprite16x16_inv[id]])
  else
    print("error draw16x16 ",x,y,id,#g.lsprite16x16)
  end
end

-------------- world 6x4
g.World={}
g.World.Create=function(t)
local i,j
local lt={}
  for j=1,4 do
    for i=1,6 do
      if(type(t[j][i])=="number")then
        table.insert( lt, t[j][i])
      else
        table.insert( lt, -1)
      end
    end
  end
  return lt
end
g.World.Get=function(x,y,t)
  return t[(y-1)*6+x]
end
g.World.Draw=function(t)
  local i,j
  local dx=0 
  for i=1,4 do
    for j=1,6 do
      if(i%2==0)then
        dx=5
      else
        dx=0
      end
      if(type(t[(i-1)*6+j])=="number")then
        if(t[(i-1)*6+j]>0)then 
          g.Sprite.Draw(dx+(j*10)-5, 3+(i-1)*9,t[(i-1)*6+j])
        elseif(t[(i-1)*6+j]==0)then
          g.Sprite.Draw(dx+(j*10)-5, 3+(i-1)*9,3)
        end
      end
    end
  end
end

g.Map={lt={},curant_id=0}
g.Map.Create=function(t)
  local i,j
  local lm={}
  for i=1,5 do
    for j=1,9 do
      table.insert(lm,t[i][j])
    end
  end
  table.insert(g.Map.lt, lm)
end
g.Map.Get=function(x,y,id)
  if(type(g.Map.lt[id][(y*9)+x+1])=="number")then return g.Map.lt[id][(y*9)+x+1] end
  return -1
end
g.Map.SetCurantId=function(id)
  g.Map.curant_id=id
end
g.Map.Draw=function()
  if(g.Map.curant_id>0)then
    for i=1,5 do
      for j=1,9 do
        if(g.Map.lt[g.Map.curant_id][((i-1)*9)+j]~=0)then
          --g.Sprite.Draw(1+(j-1)*8,1+(i-1)*8,t[((i-1)*9)+j])
          g.Tile.Draw(1+(j-1)*8,1+(i-1)*8,
            g.Map.lt[g.Map.curant_id][((i-1)*9)+j])
        end
      end
    end
  end
end
g.Map.DrawAt=function(x,y,id)
  g.Sprite.Draw(1+x*8,1+y*8,id)
end

g.Tile={ltile={}}
g.Tile.Add=function(spr,inv)
  if(inv==nil)then inv=0 end
  if(#spr==8 and spr[1]:len()==8)then
    table.insert(g.Tile.ltile,getsprite(spr,inv))
  end
end
g.Tile.Draw=function(x,y,id)
  if (id <= #g.Tile.ltile and id > 0) then 
    vthumb.Sprite(x,y,g.Tile.ltile[id]) 
  else 
    print("g.Tile.Draw() id "..id.." don t exist")
  end
end

g.Unitee={
  lstunitee={}
}
g.Unitee.Create=function(name,id,iv_id,bid,iv_bid,php_max,pmov_max)
  local lu={
    name=name,
    x=0,
    y=0,
    id=id,
    id2=iv_id,
    bid=bid,
    bid2=iv_bid,
    hp_max=php_max,
    mov_max=pmov_max,
    hp=php_max,
    mov=pmov_max
  }
  table.insert(g.Unitee.lstunitee,lu)
end
g.Unitee.Get=function(name,inv)
  local lt={name="",id=0}
  for n,v in pairs(g.Unitee.lstunitee)do
    if(v.name==name)then
      lt.name = v.name
      if(inv==nil)then
        lt.id=v.id
        lt.bid=v.bid
      elseif(inv==-1)then
        lt.id=v.id2
        lt.bid=v.bid2
      end     
      lt.x=0
      lt.y=0
      lt.hp_max=v.hp_max
      lt.mov_max=v.mov_max
      lt.hp=v.hp_max
      lt.mov=v.mov_max
      break
    end
  end
  return lt
end
g.Unitee.Generate=function(name,x,y,inv)
  local lu = g.Unitee.Get(name,inv)
  lu.x = x
  lu.y = y 
  if(inv==nil)then 
    lu.team=0
  elseif(inv==-1)then 
    lu.team=1
  end
  return lu
end


g.Team={lstunitee={}}
g.Team.Add=function(name,x,y,team)
  if(team==1)then
    table.insert(g.Team.lstunitee,g.Unitee.Generate(name,x,y,-1))
  else
    table.insert(g.Team.lstunitee,g.Unitee.Generate(name,x,y))
  end
end
g.Team.Remove=function(id)
  table.remove(g.Team.lstunitee, id)
end
g.Team.Get=function(x,y)
local n,v
  for n,v in pairs(g.Team.lstunitee)do
    if( v.x == x and v.y == y)then
      return n
    end
  end
  return -1
end
g.Team.Move=function(id,x,y)
  local dist = math.abs(g.Team.lstunitee[id].x-x)+math.abs(g.Team.lstunitee[id].y-y)
	if(g.Team.lstunitee[id].mov >= dist)then
	print(dist,g.Team.lstunitee[id].mov)
	g.Team.lstunitee[id].x = x
	g.Team.lstunitee[id].y = y
	g.Team.lstunitee[id].mov = g.Team.lstunitee[id].mov - dist
	end
end
g.Team.Atk=function(id1,id2)
	if(g.Team.lstunitee[id1].team ~= g.Team.lstunitee[id2].team)then
	print("id1 = "..id1,"atk id2 = "..id2)
	end 
end
g.Team.Draw=function()
    for n,v in pairs(g.Team.lstunitee)do
      g.Map.DrawAt(v.x,v.y,v.id)
    end
end

g.Font={lstfont={},lstw={}}
g.Font.Create=function(car,spr,width)
  g.Font.lstfont[car]=spr
  g.Font.lstw[car]=width
end
g.Font.Draw=function(car,x,y)
  if(type(g.Font.lstfont[car])== "table")then
    vthumb.Sprite(x,y,g.Font.lstfont[car])
  else print(car.." no reconize")
  end
end
g.Font.Print=function(str,x,y)
  local i
  local car
  local pw=0
  for i=1,string.len(str) do
    car = string.sub(str,i,i)
    if(type(g.Font.lstw[car])=="number")then
      g.Font.Draw(car,x+pw,y)
      pw = pw + g.Font.lstw[car]+1
    end
  end
end

g.Cursor={
	x=0,
	y=0,
	id_select=-1
}
-- interface
g.Inter={lstinter={},inter}
g.Inter.Create=function(name,update,draw)
	li = {name=name,fupdate=update,fdraw=draw}
	g.Inter.lstinter[name] = li
end
g.Inter.Set=function(name)
	g.Inter.inter = g.Inter.lstinter[name]
end
g.Inter.Draw=function()
	if(type(g.Inter.inter)=="table")then
		g.Inter.inter.fupdate(g)
		g.Inter.inter.fdraw(g)
	end
end


g.Anim={lstani={}}
g.Anim.Create=function()

end

g.Anim.Update=function()

end

return g
