--[[ Ghost Chase by Cameron Blankenship
    
This is the final project for CS50. A simple game where the player 
moves left or right collecting projectiles to shoot at a ghost that 
constantly gives chase. 

Use the ARROW keys or 'A' and 'D' to move the player.]]


Class = require 'class'
push = require 'push'

require 'Util'
require 'Map'
require 'Ghost'
require 'Player'
require 'Projectile'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()

    math.randomseed(os.time())

    -- sets up the screen and initializes the gameScore and gameState
    gameScore = 0
    gameState = 'main'

    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizeable = false,
        vsync = true
    })
    love.window.setTitle('Ghost Chase')

    -- font variables
    startFont = love.graphics.newFont('fonts/Fipps-Regular.otf', 8)
    bigFont = love.graphics.newFont('fonts/Fipps-Regular.otf', 28)

    -- loads the map
    map = Map()

    -- loads the ghost
    ghost = Ghost()

    -- loads the player
    player = Player()

    -- loads the projectile
    projectile = Projectile()

end

function love.update(dt)

    -- updates the ghost object
    if gameState == 'play' then

        -- updates the ghost, player, and projectile
        ghost:update(dt)
        player:update(dt)
        projectile:update(dt)

        -- checks for collision with ghost
        ghost:collides(dt)

        -- checks for the winning or losing condition
        if ghost.health < 0 or player.lives < 1 then

            gameState = 'done'
            ghost.speedX = 0
            ghost.speedY = 0

        end
    end
end

function love.draw()
    
    push:apply('start')
    
    if gameState == 'main' then

        -- draws the main menu
        map:renderMain()
        
    elseif gameState == 'play' then

        -- draws the play state map, ghost, player, and projectile
        map:renderPlay()
        ghost:render()
        player:render()
        projectile:render()

    elseif gameState == 'done' then

        -- draws the endgame map
        map:renderEnd()

    end

    push:apply('end')

end

function love.keypressed(key)

    if key == 'escape' then

        -- quits the game
        love.event.quit()

    
    elseif key == 'return' or key == 'enter' then

        -- starts or resets the game
        love.reset()

    end

    -- controls the ghost hit, updating shots and gameScore
    if key == 'space' and player.shots > 0 then

        player.shots = player.shots - 1
        gameScore = gameScore + 1
        ghost:hit()

    end

end

-- resets the game to play state
function love:reset()
    
    -- gameState
    gameState = 'play'
    gameScore = 0

    -- objects
    ghost:reset()
    projectile:reset()
    player:reset()
    
    -- music
    map.music['win']:stop()
    map.music['lose']:stop()
    map.music['music']:play()

end