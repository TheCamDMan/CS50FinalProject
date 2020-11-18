Ghost = Class{}

require 'Player'

function Ghost:init()

    -- generates the ghost quads from spritesheets
    self.spritesheetChasing = love.graphics.newImage('graphics/Chasing_Ghost.png')
    self.spritesheet = love.graphics.newImage('graphics/Scary_Ghost.png')
    self.tileWidth = 16
    self.tileHeight = 16
    self.tileSpritesChasing = generateQuads(self.spritesheetChasing, self.tileWidth, self.tileHeight)
    self.tileSprites = generateQuads(self.spritesheet, self.tileWidth, self.tileHeight)

    -- establishes x-positiojn, y-position, and rates of change 
    self.x = 5
    self.y = 5
    self.speedX = 0
    self.speedY = 0

    -- direction in which the ghost is facing
    self.direction = -2

    -- defines the healh of ghost and link of health bar
    self.health = 100

    -- a table containing sound effects
    self.sound = {

        ['ghostHit'] = love.audio.newSource('sounds/Powerup8.wav', 'static'),
        ['playerHit'] = love.audio.newSource('sounds/playerHit.wav', 'static')

    }
    self.sound['playerHit']:setVolume(0.25)
    self.sound['ghostHit']:setVolume(0.25)
    
end

-- updates the ghost postion relative to the player postion
function Ghost:update(dt)

    -- updates the y-position
    if self.y < player.y then
        self.y = self.y + self.speedY * dt
    end

    -- updates the x-position
    if self.x < player.x then
        self.direction = -2
        self.x = (self.x - .2) + self.speedX * dt
    elseif self.x > player.x + player.tileWidth then
        self.direction = 2
        self.x = (self.x - .2) - self.speedX * dt
    end

end

-- draws the ghost, updating the transparency relative to the player position
function Ghost:render()

    if self.x > player.x / 2 and self.y < player.y - 30 then

        love.graphics.setColor(1, 1, 1, .7)
        love.graphics.draw(self.spritesheet, self.tileSprites[2], self.x, self.y, 0, 
            self.direction, 2, self.tileWidth / 2, self.tileHeight / 2)

    elseif self.x > player.x / 2 and self.y > player.y - 30 then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.spritesheetChasing, self.tileSpritesChasing[1], self.x, self.y, 0, 
            self.direction, 2, self.tileWidth / 2, self.tileHeight / 2)

    else

        love.graphics.setColor(1, 1, 1, .4)
        love.graphics.draw(self.spritesheet, self.tileSprites[1], self.x, self.y, 0, 
            self.direction, 2, self.tileWidth / 2, self.tileHeight / 2)

    end

    -- renders the ghost health bar
    self:renderHealth()
end

-- checks for collision with the player, resets if true, updates player lives
function Ghost:collides(dt)

    if self.y > player.y - player.tileHeight then

        if self.x > player.x and self.x < player.x + player.tileWidth then

            self:reset()
            self.sound['playerHit']:play()
            player.lives = player.lives - 1

        end
    end
end

-- controls ghost movement when hit with projectile
function Ghost:hit()

    if player.x > self.x then

        self.x = math.max(10, self.x - 60)
        self.y = math.max(0, self.y - 80)
    elseif player.x < self.x then

        self.x = math.min(self.x + 60, VIRTUAL_WIDTH)
        self.y = math.max(0, self.y - 80)

    end

    self.speedX = self.speedX + 15
    self.speedY = self.speedY + 10
    self.health = self.health - 15
    self.sound['ghostHit']:play()

end

-- reset the ghost
function Ghost:reset()

    self.x = 0
    self.y = 50
    self.speedX = 40
    self.speedY = 30
    self.health = 100

end

-- draws the ghost health bar
function Ghost:renderHealth() 

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('fill', 163, 5 , self.health, 10)

end