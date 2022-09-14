--[[
    MainScreenState
    Author: Quan Tran

    Title screen of the game, press space to switch to the countdown state 
]]

MainScreenState = Class{__includes = BaseState}
--[[
	Updating function of the state
]]
function MainScreenState:update(dt)
	-- Switch to play state when space was pressed
	if love.keyboard.wasPressed('space') then
		gStateMachine:change('countdown')
	end
end
--[[
	Rendering function for state
]]
function MainScreenState:render()
	-- Render string on to the main screen
	love.graphics.setFont(gFont['medimum'])
	love.graphics.printf('Forest Runner', 0, 64, VIRTUAL_WIDTH, 'center')
	love.graphics.setFont(gFont['medimum'])
	love.graphics.printf('Press SPACE to play', 0, 100, VIRTUAL_WIDTH, 'center')
end	