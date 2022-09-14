--[[
    PlayState Class
    Author: Quan Tran

    The PlayState class is core of the game, where every gameplay events and update happens,
    player controlling the character, updating score, rendering obstacles and fruits
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
	self.player = Chara()
	-- Table for obstacles and fruits
	self.obstacles = {}
	self.fruits = {}
	-- Initializing timer
	self.diffTimer = 0
	self.spawnTimer = 0
	self.fruitTimer = 0
	-- Score
	self.score = 0
	self.difficulty = 1
	-- Initialzing last spawn time
	self.lastX = 0
end

function PlayState:update(dt)

	-- Ongoing Timer
	self.spawnTimer = self.spawnTimer + dt
	self.diffTimer = self.diffTimer + dt
	self.fruitTimer = self.fruitTimer + dt

	-- Adding score time
	self.score = self.score + math.floor(dt * 100)

	-- Increase difficulty through time, cap is Speed * 1.05, further testing 
	-- is needed for more balanced speed cap
	-- For every 10 sec, increase the difficulty
	if self.diffTimer > 10 then
		if self.difficulty < 1.05 then
			self.difficulty = self.difficulty + 0.003
		end
		-- Reset after increasing
		self.diffTimer = 0
	end
	-- Setting a spawn time variable, delta time between obstacle
	-- between 0.7s and 7s
	local spawn = math.random(70, 700)
	-- The difference between last spawn time and the current
	-- to spawn the fruit in between obstacle
	local temp2 = math.abs(self.lastX - spawn) * 0.01
	-- Spawning fruits when delta time between spawn and last
	-- spawn is more than 1.4s double the minimum cap
	if temp2 >= 1.4 then
		if self.fruitTimer > 0.13 then
			-- Spawning fruit, using random skin
			table.insert(self.fruits, Fruit(math.random(5)))
		end
		self.fruitTimer = 0
	end	

	-- Spawning the obstacle
	if self.spawnTimer > spawn * 0.01 then
		-- Increase the speed here, so that obstacle already spawn
		-- doesn't suddenly speed up
		gGameSpeed = gGameSpeed * self.difficulty
		-- Spawn a rino or saw randomly
		local temp = math.random(1,2)
		if temp == 1 then
			table.insert(self.obstacles, Rino())
		end
		if temp == 2 then
			table.insert(self.obstacles, Saw())
		end
		-- Setting current spawn time as last spawn
		self.lastX = spawn
		-- Reseting spawn timer
		self.spawnTimer = 0
	end	
	-- Update player
	self.player:update(dt)
	-- Update fruits
	for i, fruit in pairs(self.fruits) do
		fruit:update(dt)
		-- If player collide with fruit, then remove fruit and
		-- add bonus score
		if self.player:collides(fruit) then
			gSound['pickup']:play()
			fruit.remove = true
			fruit.score = true
		end
		-- Add 100 score per fruit
		if fruit.score then
			self.score = self.score + 100
			fruit.score = false
		end

		if fruit.remove then
			table.remove(fruit, i)
		end
	end	
	-- Update obstacle
	for i, obstacle in pairs(self.obstacles) do
		obstacle:update(dt)
		-- if player collides with obstacle, switch state to score state 
		if self.player:collides(obstacle) then
			-- Play a sound when player collide with obstacle
			gSound['hurt']:play()
			-- Addding score to another state
			self.difficulty = 1
			gStateMachine:change('score', {score = self.score })
		end

		if obstacle.remove then
			table.remove(obstacle, i)
		end
	end
end

function PlayState:render()
	--Render obstacles
	for i, obstacle in pairs(self.obstacles) do
		obstacle:render()
	end
	-- Render fruits
	for i, fruit in pairs(self.fruits) do
		fruit:render()
	end	
	-- Rendering current score at the top left
	love.graphics.setFont(gFont['medimum'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

	self.player:render()
end	



