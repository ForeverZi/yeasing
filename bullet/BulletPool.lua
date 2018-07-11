local BulletConstants = import(".BulletConstants")

local BulletPool = {}

function BulletPool.new(params)
    local obj = {}
    setmetatable(obj, {__index=BulletPool})
    obj:init(params)
    return obj
end

function BulletPool:init(params)
    self.bulletLayer = params.bulletLayer
    self.bullets = {}
    self.triggers = {}
    self.speed =  1
end

function BulletPool:addBullet(bullet, zOrder)
    local view = bullet:getView()
    zOrder = zOrder or BulletConstants.BULLET_Z_ORDER.TOP
    if checkNodeExist(view) and checkNodeExist(self.bulletLayer) then
        self.bulletLayer:addChild(view, zOrder)
        table.insert(self.bullets, bullet)
    end
end

function BulletPool:addTrigger(trigger)
    table.insert(self.triggers, trigger)
end

function BulletPool:update()
    local count = math.floor(self.speed)
    for _=1,count do
        local invalidBullets = filterArray(self.bullets, function(e)
            return e:getStatus()==BulletConstants.BULLET_STATUS.OVER
        end)
        self.bullets = filterArray(self.bullets, function(e)
            return e:getStatus()~=BulletConstants.BULLET_STATUS.OVER
        end)
        for _,v in pairs(invalidBullets) do
            safeRemoveNode(v:getView())
            safeRemoveNode(v:getBoomEffect())
        end
        for _,v in ipairs(self.bullets) do
            v:update()
            for _,trigger in ipairs(self.triggers) do
                -- trigger设计给bullet使用的，因此每次测试都需要重新绑定bullet
                trigger:bind(v)
                trigger:update()
            end
        end
    end
end

function BulletPool:setSpeed(speed)
    self.speed = speed
end

function BulletPool:getBulletLayer()
    return self.bulletLayer
end

function BulletPool:clear()
    local bullets = self.bullets
    self.bullets = {}
    for _,v in ipairs(bullets) do
        safeRemoveNode(v:getView())
        safeRemoveNode(v:getBoomEffect())
    end
end

return BulletPool
