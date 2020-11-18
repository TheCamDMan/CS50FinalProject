Map = Class{}

-- sets up map with spritesheet and music
function Map:init()

    self.spritesheet = love.graphics.newImage('graphics/pave.png')
    self.tileWidth = 40
    self.tileHeight = 40
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)
    self.music = {

        ['main'] = love.audio.newSource('sounds/mainPage.mp3', 'static'),
        ['win'] = love.audio.newSource('sounds/win.mp3', 'static'),
        ['music'] = love.audio.newSource('sounds/backgroundGameMusic.mp3', 'static'),
        ['lose'] = love.audio.newSource('sounds/lose.mp3', 'static')

    }
    self.music['music']:setLooping(true)
    self.music['music']:setVolume(0.25)
    
end

-- draws the gamestate 'play' map
function Map:renderPlay()

    self.music['main']:stop()
    self.music['music']:play()
    
    love.graphics.setFont(startFont)
    love.graphics.printf('Survive the night!', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Shots' .. ' ' .. player.shots, 5, 0, 50, 'left')

    -- draws the floor tiles
    for i = 0, VIRTUAL_WIDTH do
        love.graphics.draw(self.spritesheet, self.tileSprites[1], self.tileWidth * i, VIRTUAL_HEIGHT - 20)
    end
    
    -- draws the hearts representing lives of player
    hearts = love.graphics.newImage('graphics/pixel-heart.png')
    
    if player.lives == 1 then
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 125, 0, 0, .06, .06)
    elseif player.lives == 2 then
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 90, 0, 0, .06, .06)
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 125, 0, 0, .06, .06)
    elseif player.lives == 3 then
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 55, 0, 0, .06, .06)
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 90, 0, 0, .06, .06)
        love.graphics.draw(hearts, VIRTUAL_WIDTH - 125, 0, 0, .06, .06)

    end
end

-- draws the gamestate 'main' map and sets music
function Map:renderMain()

    love.graphics.setFont(bigFont)
    love.graphics.printf('Ghost Chase!', 0, 50, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(startFont)
    love.graphics.printf('Use ARROW keys to collect packages. Use SPACE to shoot the Ghost!', 90, VIRTUAL_HEIGHT - 80, 250, 'center')
    love.graphics.setColor(1,0,0,1)
    love.graphics.printf('press enter to play', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('By Cameron Blankenship @TheCamDMan', 0, 0, 200, 'left')
    love.graphics.printf('New York, NY USA', 0, 0, VIRTUAL_WIDTH, 'right')

    self.music['main']:play()
    self.music['music']:setLooping(true)
    self.music['music']:setVolume(0.25)
end

-- draws the gamestate 'done' page
function Map:renderEnd()

    -- renders if player lost
    if player.lives < 1 then

        love.graphics.clear(0, 0, 0, 1)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setFont(bigFont)
        love.graphics.printf("You lose!", 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(startFont)
        love.graphics.printf('press ENTER to play again', 0, 200, VIRTUAL_WIDTH, 'center')

        self.music['music']:stop()
        self.music['lose']:play()
        self.music['lose']:setLooping(true)
        self.music['lose']:setVolume(0.25)

    else

        -- renders if player wins
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.setFont(bigFont)
        love.graphics.printf('You Win!', 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(startFont)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('press ENTER to play again', 0, 200, VIRTUAL_WIDTH, 'center')

        self.music['music']:stop()
        self.music['win']:play()
        self.music['win']:setLooping(true)
        self.music['win']:setVolume(0.25)

    end
end

