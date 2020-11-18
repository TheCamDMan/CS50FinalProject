Projectile = Class{}

require 'Player'

-- sets the x-position and rate of change on y-axis
function Projectile:init()

    self.x = math.random(VIRTUAL_WIDTH - 10)
    self.y = 0
    self.dy = 175

    self.sound = love.audio.newSource('sounds/Pickup_Coin15.wav', 'static')

end

-- updates the y-position and checks for self:collected 
function Projectile:update(dt)

    -- updates y-position by self.dy
    self.y = self.y + self.dy * dt

    -- resets if y-position is past bottom of window
    if self.y > VIRTUAL_HEIGHT then
        self:reset()
    end

    --[[ checks for collision with player based on y-position and 
        x-position ]]--
    if self.y + 10 > player.y - player.tileHeight / 2 then

        if self.x > player.x - player.tileWidth / 2 and 
            self.x < player.x + player.tileWidth / 2 then

            player.shots = player.shots + 1
            self.sound:play()
            self:reset()

        elseif self.x + 10 > player.x - player.tileWidth / 2 and 
            self.x + 10 < player.x + player.tileWidth / 2 then

            player.shots = player.shots + 1
            self.sound:play()
            self:reset()

        end
    end
end

-- draws the pojectile
function Projectile:render()

    love.graphics.setColor(self.R, self.G, self.B)
    love.graphics.rectangle('fill', self.x, self.y, 10, 10)

end

-- resets the projectile
function Projectile:reset()
    self.x = math.random(VIRTUAL_WIDTH - 10)
    self.y = 0
    self.R = love.math.random(255) / 255
    self.G = love.math.random(255) / 255
    self.B = love.math.random(255) / 255
end