intro = {}

function intro:enter()
	local height = love.graphics.getHeight( )
	local fontSize = 60 * height / 1200
	love.graphics.setFont(love.graphics.newFont(fontSize))
	love.graphics.setBackgroundColor( 77, 166, 75, 255 )
end

function intro:draw()
	love.graphics.print("GreenGrow,\na game made for ludum dare 34\nReach the Sun. Escape Fire. Grow.", 10, 10)
    love.graphics.print("Press Enter to continue", love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
end

function intro:keypressed(key, code)
    if key == 'return' then
        Gamestate.switch(menu)
    end
    if key == 'escape' then
        love.event.quit()
    end
end