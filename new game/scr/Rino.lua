--[[
    Rino Class
    Author: Quan Tran

    The Rino class represents the rinos that randomly spawn in the game, which act as the primary obstacles.
    When the player collides with one of them, it's game over.
]]

Rino = Class{}

--[[
	Initializing function, to initialize field variables
]]
function Rino:init()
	-- Getting image from disk
	self.image = love.graphics.newImage('graphics/rino.png')
	-- Object width and height
	self.width = 52
	self.height = 34

	-- Object velocity
	self.dx = gGameSpeed

	-- initial x and y position
	self.x = VIRTUAL_WIDTH + 32
	self.y = VIRTUAL_HEIGHT - self.height - 20
	-- Remove varible
	self.remove = false
	-- Animation via anim8
	-- Creating Quads and animation
	self.g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
	self.animation = anim8.newAnimation(self.g('1-6',1),0.1)
end

--[[
	Updating function for object
]]
function Rino:update(dt)
	-- Remove the object if go out of screen
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
function Rino:render()
	-- Animating the rino
	self.animation:draw(self.image,self.x,self.y)
end	