--[[
    Countdown State
    Author: Quan Tran

    Counts down visually on the screen (3,2,1,GO) so that the player knows the
    game is about to begin. Transitions to the PlayState as soon as the
    countdown is complete.
]]

CountdownState = Class{__includes = BaseState}


-- 0.75s per each countdown
COUNTDOWN_TIME = 0.75
--[[
	Initialize all field variable
]]
function CountdownState:init()
	self.count = 4
	self.timer = 0
end
--[[
	Updating function for state
]]
function CountdownState:update(dt)
	-- Updating timer per delta time
	self.timer = self.timer + dt
	-- When timer > 0.75s, modulo itself and decrease count by 1
	if self.timer > COUNTDOWN_TIME then
		self.timer = self.timer % COUNTDOWN_TIME
		self.count = self.count - 1
		-- Play sound as each timer goes down
		if self.count > 1 then
			gSound['countdown']:play()
		end
		-- Change state to play when countdown = 0
		if self.count == 0 then
			gStateMachine:change('play')
		-- Play sound for last countdown
		elseif self.count == 1 then
			gSound['countdown2']:play()
		end
	end
end	

function CountdownState:render()

	-- Render the last countdown
	if self.count == 1 then
		love.graphics.setFont(gFont['medimum'])
		love.graphics.printf('STOP WASTING YOUR TIME!!',0, 120, VIRTUAL_WIDTH, 'center')
	-- Render the 3 , 2, 1
	else
		love.graphics.setFont(gFont['countdown'])
		love.graphics.printf(tostring(self.count - 1),0,100, VIRTUAL_WIDTH, 'center')
	end
end