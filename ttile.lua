require "globals"

TTile = {}
TTile.__index = TTile

function TTile.create(x, y, ground_type, i)
   	local tile = {}
   	setmetatable(tile, TTile)
        tile.b = love.physics.newBody(world, x + Globals.getInstance().getTranslation(), y + Globals.getInstance().getTranslation(), "static") 
        tile.s = love.physics.newRectangleShape(Globals.getInstance().getTileSize(), Globals.getInstance().getTileSize())
        tile.f = love.physics.newFixture(tile.b, tile.s)
        tile.f:setUserData(ground_type)
        tile.f:setCategory(i)
	return tile
end