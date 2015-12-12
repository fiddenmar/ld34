require "globals"

Player = {}
Player.__index = Player

function Player.create(x, y)
   	local player = {}
   	setmetatable(player, Player)
        player.b = love.physics.newBody(world, x + Globals.getInstance().getTranslation(), y + Globals.getInstance().getTranslation(), "dynamic")
        player.b:setMass(100) 
        player.b:setInertia(1000)
        player.s = love.physics.newRectangleShape(Globals.getInstance().getTileSize(), Globals.getInstance().getTileSize())
        player.f = love.physics.newFixture(player.b, player.s)
        player.f:setUserData("player")
    player.deleting = false
    player.static = false
	player.xSpeedLimit = 100
	player.onAir = false
	player.normalImage = love.graphics.newImage("img/player.png")
	player.staticImage = love.graphics.newImage("img/staticPlayer.png")
	player.startX = x
	player.startY = y
	return player
end

function Player:handleInput(dt)
	if love.keyboard.isDown("right") then
		local x, y = self.b:getLinearVelocity()
        if x < self.xSpeedLimit then
        	self.b:applyForce(100, 0)
        	self.b:setLinearVelocity(x, y)
        end
    elseif love.keyboard.isDown("left") then
        local x, y = self.b:getLinearVelocity()
        if x > -self.xSpeedLimit then
        	self.b:applyForce(-100, 0)
        	self.b:setLinearVelocity(x, y)
        end
    end
    if love.keyboard.isDown("up") and not self.onAir then
    	self.onAir = true
    	jumpSound:play()
        self.b:applyForce(0, -2300)
    end
    if love.keyboard.isDown("down") and self.onAir then
        self.b:applyForce(0, 500)
    end
end

function Player:draw()
	if not self.static then
		love.graphics.draw(self.normalImage, self.b:getX(), self.b:getY(), self.b:getAngle(),  1, 1, self.normalImage:getWidth()/2, self.normalImage:getHeight()/2)
	else
		love.graphics.draw(self.staticImage, self.b:getX(), self.b:getY(), self.b:getAngle(),  1, 1, self.staticImage:getWidth()/2, self.staticImage:getHeight()/2)
	end
end

function Player:getPosition()
	local x, y = self.b:getWorldCenter()
	return x, y
end

function Player:getAABB()
	local coord1, coord2, coord3, coord4 = self.f:getBoundingBox()
	return coord1, coord2, coord3, coord4
end

function Player:update()
	if self.deleting then
		local x = self.startX
		local y = self.startY
		self.b:destroy()
		return false, x, y
	end
	if self.static then
		self.f:setUserData("static")
		self.b:setType("static")
		self.f:setCategory(16)
		local x, y
		if #staticTiles == 0 then
			x = self.startX 
			y = self.startY
		else
			x, y = staticTiles[#staticTiles]:getPosition()
			x = x - Globals.getInstance().getTranslation()
			y = y - Globals.getInstance().getTileSize()
		end
		table.insert(staticTiles, self)
		lastPositionX, lastPositionY = staticTiles[#staticTiles]:getPosition()
		return false, x, y
	end
	return true, 0, 0
end