menu = {}

function menu:enter()
	local height = love.graphics.getHeight( )
	local fontSize = 60 * height / 1200
	love.graphics.setFont(love.graphics.newFont(fontSize))
	love.graphics.setBackgroundColor( 77, 166, 75, 255 )
end

function menu:draw()
	love.graphics.print("GreenGrow,\na game made for ludum dare 34\nReach the Sun. Escape Fire. Grow.", 10, 10)
    love.graphics.print(Globals.getInstance().getLevels()[levelNumber], love.graphics:getWidth() / 2, love.graphics:getHeight() / 2)
end

function menu:keypressed(key, code)
    if key == 'return' then
        selectSound:play()
        Gamestate.switch(game)
    end
    if key == 'escape' then
        love.event.quit()
    end
    if key == "right" then
        selectSound:play()
    	levelNumber = levelNumber+1
    end
    if key == "left" then
        selectSound:play()
    	levelNumber = levelNumber-1
    end
    if levelNumber < 1 then 
    	levelNumber = #Globals.getInstance().getLevels()
    end
    if levelNumber > #Globals.getInstance().getLevels() then
    	levelNumber = 1
    end

end