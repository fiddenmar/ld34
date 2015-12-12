Gamestate = require "hump.gamestate"

require "intro"
require "menu"
require "game"
require "win"

levelNumber = 1

function love.load()
	--love.window.setMode(0, 0, {fullscreen=true, fullscreentype="desktop", vsync=true, resizable=false})
    Gamestate.registerEvents()
    Gamestate.switch(intro)
end