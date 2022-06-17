local mygame = require("game")

lw = mygame.World.Create({
  {x,x,0,0,0,0},
  {0,4,0,0,4,0},
  {0,0,0,x,0,0},
  {0,4,0,0,x,x}
})