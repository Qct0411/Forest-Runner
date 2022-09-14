--[[
    ScoreState
    Author: Quan Tran

    Scoring state of the game, take in the score from the game state
    and display the score to screen
]]

ScoreState = Class{__includes = BaseState}
--[[
    Take in score from play, kinda like an init function from class
]]
function ScoreState:enter(params)
	self.score = params.score
    -- Randomizing the score message
    self.mess = math.random(1,4)
end	

--[[
    Updating function for class
]]
function ScoreState:update(dt)
    -- Switch to countdown
    gScore = love.highScore(gScore,self.score)
	if love.keyboard.wasPressed('space') then
        gStateMachine:change('countdown')
    end
end

--[[
    Rendering function for state
]]
function ScoreState:render()
    -- Render score into screen
    love.graphics.setFont(gFont['medimum'])
    if self.mess == 1 then
        love.graphics.printf('LOL you Lose !', 0, 50, VIRTUAL_WIDTH, 'center')
    end
    if self.mess == 2 then
        love.graphics.printf('Youre bald !', 0, 50, VIRTUAL_WIDTH, 'center')
    end
    if self.mess == 3 then
        love.graphics.printf('Dev hiscore is 50000 btw !', 0, 50, VIRTUAL_WIDTH, 'center')
    end
    if self.mess == 4 then
        love.graphics.printf('Come on try HARDER', 0, 50, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setFont(gFont['medimum'])
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 70, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('High Score: ' .. tostring(gScore), 0, 100, VIRTUAL_WIDTH, 'center' )

    love.graphics.printf('Press SPACE to Waste your Time Again!', 0, 120, VIRTUAL_WIDTH, 'center')
end