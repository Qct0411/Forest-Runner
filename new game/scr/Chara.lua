--[[
    Chara Class
    Author: Quan Tran

    The Chara is what we control in the game via clicking or the space bar; whenever we press either,
    the character will jump and go up a little bit, where it will then be affected by gravity. Include
    function to handle collision
]]

Chara = Class{}


local GRAVITY = 720
local offsetx = 0

-- Initializing player object
function Chara:init()
	-- Getting sprite from disk
	self.image = love.graphics.newImage('graphics/ninjafrog.png')
	-- Setting image width and height
	self.width = 32
	self.height = 32
	-- Initial position of player
	self.x = 100
	self.y = VIRTUAL_HEIGHT - (self.height) - 25
	self.dy = 0

	-- Animation via anim8
	-- Creating Quads and animation
	self.g = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
	self.animation = anim8.newAnimation(self.g('1-12',1),0.05)
end

--[[
	AABB collision detection system, check for overlapping 
]]
function Chara:collides(obstacle)
	-- Some constant has been added to compensate for the hitboxes of the obstacle
	-- Checking x and y to see if player and target has overlap or not
	if (self.x) + (self.width - 6) >= obstacle.x and self.x + 10 <= obstacle.x + obstacle.width - 5 then
		if (self.y + 2) + (self.height - 7) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height then
			return true
		end
	end
	return false
end	

-- Updating player parameter based on delta time
function Chara:update(dt)
	-- Flipping through the sprite sheet
	self.animation:update(dt)
	-- Applying gravity as a y-acceleration
	self.dy = self.dy + GRAVITY * dt
	-- Inputing 'space' to jump, setting if condition to eliminate
	-- multiple jump
	if self.y == VIRTUAL_HEIGHT - self.height - 20 then
		if love.keyboard.wasPressed('space') then
			gSound['jump']:play()
			self.dy = -270
		end
	end
	-- Applying velocity into position
	self.y = self.y + self.dy * dt

	-- Preventing the character from going underground
	if self.dy > 0 then
		self.y = math.min(VIRTUAL_HEIGHT - self.height - 20, self.y + self.dy * dt)
	end

end
--[[
	Rendering the character
]]
function Chara:render()
	self.animation:draw(self.image,self.x,self.y)
end