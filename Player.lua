Player = Class{}

require 'Animation'

-- sets up the player object
function Player:init()

    self.spritesheet = love.graphics.newImage('graphics/playerSpritesheet.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)
    
    -- player position and rate of change on the x-axis
    self.x = 0
    self.y = 0
    self.dx = 175

    -- direction is scaled up to make sprite larger
    self.direction = 2

    -- controls shot counter
    self.shots = 0

    -- variable controlling behavior state
    self.state = 'standing'

    -- animations available to player
    self.animations = {

        -- table representing the standing animation spritesheet, frames, and interval
        ['standing'] = Animation {
            spritesheet = self.spritesheet,
            frames = {
                self.tileSprites[1]
            },
            interval = 1
        },

        -- table representing the walking animation spritesheet, frames, and interval
        ['walking'] = Animation {
            spritesheet = self.spritesheet,
            frames = {
                self.tileSprites[2], self.tileSprites[3], self.tileSprites[4]
            },
            interval = 0.15
        }
    }

    -- ensures the animation defaults to standing
    self.animation = self.animations['standing']

    --[[ a table containing the available player behaviors
        with keyboard controls ]]--
    self.behaviors = {

        ['standing'] = function(dt)

            if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
                self.direction = 2
                self.x = math.min(self.x + self.dx * dt, VIRTUAL_WIDTH - self.tileWidth / 2)
                self.animation = self.animations['walking']
            elseif love.keyboard.isDown('left') or love.keyboard.isDown('a') then
                self.direction = -2
                self.x = math.max(self.tileWidth / 2, self.x - self.dx * dt)
                self.animation = self.animations['walking']
            else
                self.animation = self.animations['standing']
            end

        end,

        ['walking'] = function(dt)

            if love.keyboard.isDown('right') then
                self.direction = 2
                self.x = self.x + self.dx * dt
                self.animation = self.animations['walking']
            elseif love.keyboard.isDown('left') then
                self.direction = -2
                self.x = self.x + -self.dx * dt
                self.animation = self.animations['walking']
            else 
                self.animation = self.animations['standing']
            end
            
        end
    }

end

-- updates the player behavior and animation each frame
function Player:update(dt)

    self.behaviors[self.state](dt)
    self.animation:update(dt)

end

-- draws the player
function Player:render()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.spritesheet, self.animation:getCurrentFrame(), 
        math.floor(self.x), math.floor(self.y), 0, 
        self.direction, 1.5, self.tileWidth / 2, self.tileHeight / 2)

end

-- resets the player
function Player:reset()

    self.x = map.tileWidth * 5
    self.y = VIRTUAL_HEIGHT - 32
    self.shots = 0
    self.lives = 3
    
end