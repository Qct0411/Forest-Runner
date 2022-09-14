--[[
	Computer Science 12
	Forest Runner

	Author: Quan Tran
	Ver: 1.0

	A infimite runner game set in a forest. Press space to jump to avoid obstacle, collect fruits
	earn bonus points.
]]

-- Libraries
push = require 'libs/push'
Class = require 'libs/class'
anim8 = require 'libs/anim8'
require 'libs/StateMachine'

-- Require all Object Class
require 'scr/Chara'
require 'scr/Rino'
require 'scr/Saw'
require 'scr/Fruit'

-- Require all states
require 'scr/states/BaseState'
require 'scr/states/MainScreenState'
require 'scr/states/PlayState'
require 'scr/states/ScoreState'
require 'scr/states/CountdownState'

-- Constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

-- Local variables
-- Getting background layers from disk
local bgLayers = {[1] = love.graphics.newImage('graphics/plx-1.png'),
				  [2] = love.graphics.newImage('graphics/plx-2.png'),
				  [3] = love.graphics.newImage('graphics/plx-3.png'),
				  [4] = love.graphics.newImage('graphics/plx-4.png'),
				  [5] = love.graphics.newImage('graphics/plx-5.png')}

-- Current Scrolling speed for each layers
local bgScrolls = {[1] = 0,
				   [2] = 0,
				   [3] = 0,
				   [4] = 0,
				   [5] = 0}

-- Scrolling speed for layers
local BACKGROUND_SCROLL_SPEEDS = {[1] = 0,
								  [2] = 30,
								  [3] = 40,
								  [4] = 50,
								  [5] = 60}
-- Getting ground image from disks and setting its current speed and
-- scrolling speed
local GROUND_IMAGE = love.graphics.newImage('graphics/ground2.png')
local groundScroll = 0
local GROUND_SCROLL_SPEEDS = 60

--[[
	Run one time only during load game, load all global/ field and require classes and states
]]
function love.load()
	-- Basic setting for game
	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.window.setTitle('Forest Runner')
	-- Global fonts table
	gFont = {
		['medimum'] = love.graphics.newFont('fonts/font.ttf',16),
		['huge'] = love.graphics.newFont('fonts/font.ttf', 48),
		['countdown'] = love.graphics.newFont('fonts/flappy.ttf', 56)
	}
	love.graphics.setFont(gFont['medimum'])
	-- Global sounds table
	gSound = {
		['jump'] = love.audio.newSource('sound/jump.wav', 'static'),
		['hurt'] = love.audio.newSource('sound/hurt.wav', 'static'),
		['countdown'] = love.audio.newSource('sound/countdown.mp3', 'static'),
		['countdown2'] = love.audio.newSource('sound/countdown2.mp3', 'static'),
		['pickup'] = love.audio.newSource('sound/pickup.wav', 'static'),
		--Background music
		['music'] = love.audio.newSource('sound/marios_way.mp3', 'static')}
	-- Background music, looping
	gSound['music']:setLooping(true)
    gSound['music']:play()

    gScore = 0

    -- Setting the screen
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = false,
		fullscreen = false,
		resizable = true
	})

	-- Setting random seed
	math.randomseed(os.time())

	-- StateMachine with all state function
	gStateMachine = StateMachine {
		['title'] = function() return MainScreenState() end,
		['play'] = function() return PlayState() end,
		['score'] = function() return ScoreState() end,
		['countdown'] = function() return CountdownState() end
	}
	gStateMachine:change('title')

	-- Global object speed
	gGameSpeed = -200

	-- Initializing keyboard input
	love.keyboard.keysPressed = {}
end
--[[
	Reszing the screen function for the game
]]
function love.resize(w, h)
	push:resize(w, h)
end


--[[
	Run everytime when player input a keypress
]]
function love.keypressed(key)
	-- Add the key from the player to the input
	-- table and set to true
	love.keyboard.keysPressed[key] = true
	-- Quit the game when press escape
	if key == 'escape' then
		love.event.quit()
	end
end
--[[
	Function for detecting if a key was pressed
	and send back true if was pressed and false
	if was not pressed
]]
function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function love.highScore(oldScore, score)
	if oldScore < score then
		newHighScore = score
	else
		newHighScore = oldScore
	end
	return newHighScore
end	

--[[
	Update function for game, most of the code has been move to
	play state to avoid huge chunk of code
]]
function love.update(dt)
	-- Multiple layers of background, moving at different speed
	-- creating a illusion of relative speed, paralanx background
	for k = 1,5,1 do
		bgScrolls[k] = (bgScrolls[k] + BACKGROUND_SCROLL_SPEEDS[k] * dt) % VIRTUAL_WIDTH
	end
	-- Scrolling for ground
	groundScroll = (groundScroll + GROUND_SCROLL_SPEEDS * dt) % 432
	-- Update function for all state machines
	gStateMachine:update(dt)
	-- Reintialize input table
	love.keyboard.keysPressed = {}
end

--[[
	Draw function of the game, render every thing in the game
]]
function love.draw()
	push:start()
	-- Rendering background layers
	love.graphics.draw(bgLayers[1], -bgScrolls[1], 0)
	love.graphics.draw(bgLayers[2], -bgScrolls[2], 0)
	love.graphics.draw(bgLayers[3], -bgScrolls[3], 0)
	love.graphics.draw(bgLayers[4], -bgScrolls[4], 0)
	love.graphics.draw(bgLayers[5], -bgScrolls[5], 0)
	love.graphics.draw(GROUND_IMAGE, -groundScroll, VIRTUAL_HEIGHT - 25)	
	-- Render all states
	gStateMachine:render()

	push:finish()
end