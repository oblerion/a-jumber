-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")
-- Désactive le lissage en cas de scale
love.graphics.setDefaultFilter("nearest")
local vtu_en = require("vthumb")
function love.load()vtu_en.load()end
function love.update(dt)vtu_en.update(dt)end
function love.draw()vtu_en.draw()end
function love.keypressed(key)if key == "escape" then love.event.quit()end end
--local spriteMap = {255, 129, 129, 129, 129, 129, 129, 255}
local mygame = require("game")
require("data_sprite")
require("data_world")
require("data_map")
require("data_unitee")
require("data_tile")
require("data_font")
require("data_interface")

mygame.Team.Add("tank",2,1)
mygame.Team.Add("soldat",6,3,1)
mygame.Map.SetCurantId(1)
mygame.Inter.Set("ititle")
function v()
  mygame.Inter.Draw()
end
