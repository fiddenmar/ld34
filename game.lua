Loader = require "AdvTiledLoader/Loader"
	Loader.path = "maps/"
Camera = require "hump.camera"

require "globals"
require "ttile"
require "player"

local player
local allSolidTiles

game = {}

function game:enter()
	love.graphics.setBackgroundColor( 0, 0, 0, 255 )
    map = Loader.load(Globals.getInstance().getLevels()[levelNumber]..".tmx")
	
	world = love.physics.newWorld(0, 200, true)
		world:setCallbacks(beginContact, endContact, preSolve, postSolve)
 
	translateToCenterX = love.graphics:getWidth() / 2 - map.width*Globals.getInstance().getTileSize() / 2
    translateToCenterY = love.graphics:getHeight() / 2 - map.height*Globals.getInstance().getTileSize() / 2
	
	allSolidTiles, startX, startY, finishX, finishY = findTiles(map)
	lastPositionX = startX + Globals.getInstance().getTranslation()
	lastPositionY = startY + Globals.getInstance().getTranslation()
	staticTiles = {}

	player = Player.create(startX, startY)
	cam = Camera(startX, startY)
	cam:zoomTo(4)
end

function gameWon()
	Gamestate.switch(win)
end

function beginContact(a, b, coll)
	local playerObject = nil
	local tileObject = nil
	if a:getUserData() == "player" then
		playerObject = a
		tileObject = b
	elseif b:getUserData() == "player" then
		playerObject = b
		tileObject = a
	else
		return
	end
	x, y = playerObject:getBody():getLinearVelocity()
	if playerObject:getBody():getY() < tileObject:getBody():getY() and y >= 0 then
		player.onAir = false
	end

	if tileObject:getCategory() == 2 then
		gameWon()
	end

	if tileObject:getCategory() == 4 then
		player.deleting = true
		deathSound:play()
	end
end
 
function endContact(a, b, coll)

end
 
function preSolve(a, b, coll)

end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

function getNavigation(x0, y0, x1, y1, l)
	local W = x1 - x0
	local H = y1 - y0
	local L = math.sqrt(math.pow(W, 2) + math.pow(H, 2))
	local k = l / L
	local h = H * k
	local w = W * k
	return x0 + w, y0 + h
end

function game:update(dt)
    handleInput(dt)
	local alive, x, y = player:update()
	if not alive then
		player = Player.create(x, y)
	end

	if player.adopt then	
		local coord1, coord2, coord3, coord4 = player:getAABB()
		world:rayCast(coord1, coord2, coord3, coord4, adoption)
	end

	local posX, posY = player:getPosition()
	cam:lockPosition(posX, posY)

	world:update(dt)
end

function game:draw()
    cam:attach()
	map:draw()
	local x0, y0 = player:getPosition()
	local x1, y1 = getNavigation(x0, y0, finishX, finishY, 20)
	local x2, y2 = getNavigation(x0, y0, lastPositionX, lastPositionY, 20)
	local r, g, b, a = love.graphics.getColor( )
	love.graphics.setColor(255,255,102)
	love.graphics.line(x0, y0, x1, y1)
	love.graphics.setColor(0, 128, 0)
	love.graphics.line(x0, y0, x2, y2)
	love.graphics.setColor(r, g, b, a)
	player:draw()
	for _, staticTile in ipairs(staticTiles) do
		staticTile:draw()
	end
	cam:detach()
end

function handleInput(dt)
	player:handleInput(dt)
	if love.keyboard.isDown("escape") then
		selectSound:play()
		Gamestate.switch(menu)
	end
end

function game:keypressed(key)
   if key == "space" or key == " " then
      player.static = true
      staticSound:play()
   end
end

function findTiles(map)
	local startX
	local startY
	local finishX
	local finishY
	local colorTiles = {}
	local ground_types = {"start", "finish", "ground", "fire"} 

	for i, ground_type in ipairs(ground_types) do
		local layer = map.tl["map"]
		
		for tileX=1,map.width do
			for tileY=1,map.height do
				
				local tile
				
				if layer.tileData[tileY] then
					tile = map.tiles[layer.tileData[tileY][tileX]]
				end

				if tile and tile.properties[ground_type] then

					if ground_type == "start" then
						startX = (tileX-1) * Globals.getInstance().getTileSize()
						startY = (tileY-1) * Globals.getInstance().getTileSize()
					else
						if ground_type == "finish" then
							finishX = (tileX-1) * Globals.getInstance().getTileSize() + Globals.getInstance().getTranslation()
							finishY = (tileY-1) * Globals.getInstance().getTileSize() + Globals.getInstance().getTranslation()
						end
						local tile = TTile.create((tileX-1)*Globals.getInstance().getTileSize(), (tileY-1)*Globals.getInstance().getTileSize(), ground_type, i)
						table.insert(colorTiles, tile)
					end
				end
			end
		end
	end
	
	return colorTiles, startX, startY, finishX, finishY
end