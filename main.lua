Gamestate = require "hump.gamestate"

require "intro"
require "menu"
require "game"
require "win"

levelNumber = 1
selectSound = love.audio.newSource("sound/select.wav", "static")
deathSound = love.audio.newSource("sound/death.wav", "static")
jumpSound = love.audio.newSource("sound/jump.wav", "static")
jumpSound:setPitch(0.25)
staticSound = love.audio.newSource("sound/static.wav", "static")

function love.load()
	--love.window.setMode(0, 0, {fullscreen=true, fullscreentype="desktop", vsync=true, resizable=false})
	love.window.setTitle( "GreenGrow" )
    Gamestate.registerEvents()
    Gamestate.switch(intro)
end