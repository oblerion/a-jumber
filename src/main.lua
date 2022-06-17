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

require("screen_title")
require("screen_game")

local mode = 0
function v()
  if(mode==0)then 
    title()
    if( vthumb.buttonA.pressed==true or 
        vthumb.buttonB.pressed==true or 
        vthumb.buttonU.pressed==true or 
        vthumb.buttonD.pressed==true or 
        vthumb.buttonL.pressed==true or
        vthumb.buttonR.pressed==true)then
      mode=1
    end
  elseif (mode==1) then
    game()
  end
end
