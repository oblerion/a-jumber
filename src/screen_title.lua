local mygame = require("game")

function title()
  mygame.Font.Print("A-JUMBER",16,1)
  mygame.Font.Print("tactic fight",16,9)
	mygame.Map.DrawAt(1,4,mygame.Unitee.Get("VTM").id)
	mygame.Map.DrawAt(3,4,mygame.Unitee.Get("tank").id)
	mygame.Map.DrawAt(7,4,mygame.Unitee.Get("soldat",-1).id)
	mygame.Map.DrawAt(5,3,mygame.Unitee.Get("avion",-1).id)
end