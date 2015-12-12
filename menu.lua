menu = {}

function menu:enter()
	local height = love.graphics.getHeight( )
	local fontSize = 60 * height / 1200
	love.graphics.setFont(love.graphics.newFont(fontSize))
	love.graphics.setBackgroundColor( 77, 166, 75, 255 )
end

function menu:draw()
	love.graphics.print("GreenGrow,\na game made for ludum dare 34\nReach the Sun. Escape Fire. Grow.", 10, 10)
    love.graphics.print("Press Enter to continue", love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
end

function menu:keypressed(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
    if key == 'escape' then
        love.event.quit()
    end
end