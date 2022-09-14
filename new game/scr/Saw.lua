--[[
    Saw Class
    Author: Quan Tran

    The Saw class represents the saws that randomly spawn in the game, which act as the primary obstacles.
    When the player collides with one of them, it's game over.
]]

Saw = Class{}

--[[
	Initializing function, to initialize field variables
]]
function Saw:init()
	-- Getting image from disk
	self.image = love.graphics.newImage('graphics/saw.png')
	-- Object width and height
	self.width = 38
	self.height = 38
	-- Initial x and y postion
	self.x = VIRTUAL_WIDTH + 32
	self.y = VIRTUAL_HEIGHT - self.height - 20
	-- Object velocity
	self.dx = gGameSpeed
	-- Remove variable
	self.remove = false
	-- Animation via anim8
	-- Create Quads and animation
	self.g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
	self.animation = anim8.newAnimation(self.g('1-8',1),0.1)
end

--[[
	Updating function for object
]]
function Saw:update(dt)
	-- Remove the object if go out of the screen
	if self.x > -self.width then
		self.animation:update(dt)
		-- Applying velocity to position
		self.x = self.x + self.dx * dt
	else
		self.remove = true
	end

end

--[[
	Rendering function for object
]]
function Saw:render()
	-- Animating the saw
	self.animation:draw(self.image,self.x,self.y)
end	