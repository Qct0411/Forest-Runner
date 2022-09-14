--[[
    Fruit Class
    Author: Quan Tran

    The Fruit class is for bonus points in the game, with 5 skins.
]]

Fruit = Class {}

-- Table for different skins
local image = {
['strawberry'] = love.graphics.newImage('graphics/fruits/Strawberry.png'),
['kiwi'] = love.graphics.newImage('graphics/fruits/Kiwi.png'),
['orange'] = love.graphics.newImage('graphics/fruits/Orange.png'),
['pineapple'] = love.graphics.newImage('graphics/fruits/Pineapple.png'),
['melon'] = love.graphics.newImage('graphics/fruits/Melon.png')}


--[[
	Initializing function, to initialize field variables
]]
function Fruit:init(skin)
	-- Object width and height
	self.width = 32
	self.height = 32
	-- Setting velocity as gGameSpeed for increasing speed in game
	self.dx = gGameSpeed
	self.x = VIRTUAL_WIDTH + 32
	self.y = VIRTUAL_HEIGHT - self.height - 70
	-- Remove boolean
	self.remove = false
	-- Input skin from play state
	self.skin = skin
	-- Scoring variable
	self.score = false
	-- Animation via anim8
	-- Creating Quads and animation
	self.g = anim8.newGrid(self.width, self.height, image['strawberry']:getWidth(), image['strawberry']:getHeight())
	self.animation = anim8.newAnimation(self.g('1-17',1),0.1)
end

--[[
	Updating function for object
]]
function Fruit:update(dt)
	-- Remove the object if go out of screen
	if self.x > -self.width then
		self.animation:update(dt)
		-- Applying velocity into position
		self.x = self.x + self.dx * dt
	else
		self.remove = true
	end
end

--[[
	Rendering function for object
]]
function Fruit:render()
	-- Render the skins
	-- Stop rendering if remove = true
	if self.remove == false then
		if self.skin == 1 then
			self.animation:draw(image['strawberry'],self.x,self.y)
		elseif self.skin == 2 then
			self.animation:draw(image['kiwi'],self.x,self.y)
		elseif self.skin == 3 then
			self.animation:draw(image['orange'],self.x,self.y)
		elseif self.skin == 4 then
			self.animation:draw(image['pineapple'],self.x,self.y)
		else
			self.animation:draw(image['melon'],self.x,self.y)
		end
	end
end	