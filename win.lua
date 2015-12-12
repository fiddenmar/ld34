win = {}

function win:enter()
	local height = love.graphics.getHeight( )
	local fontSize = 60 * height / 1200
	love.graphics.setFont(love.graphics.newFont(fontSize))
	love.graphics.setBackgroundColor( 77, 166, 75, 255 )
end

function win:draw()
	love.graphics.print("GreenGrow,\na game made for ludum dare 34\nReach the Sun. Escape Fire. Grow.", 10, 10)
    love.graphics.print("Level completed\nPress Enter to continue", love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
end

function win:keypressed(key, code)
    if key == 'return' then
    	levelNumber = levelNumber + 1
        Gamestate.switch(game)
    end
    if key == 'escape' then
        Gamestate.switch(menu)
    end
end