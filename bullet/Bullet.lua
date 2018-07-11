local BulletConstants = import(".BulletConstants")
local util = import(".BulletUtil")

local Bullet = {}

function Bullet.new(params)
    local obj = {}
    setmetatable(obj, {__index=Bullet})
    obj:init(params)
    return obj
end

function Bullet:init(params)
    self.subBullets = {}
    self.triggers = {}
    -- 这个view应该被正确设置好初始位置
    self.view = params.view
    self.trace = params.trace
    -- 仅支持spine配置
    self.boomEffectCfg = params.boomEffectCfg
    self.onBoomCallBack = params.onBoomCallBack
    self.status = BulletConstants.BULLET_STATUS.INIT
    self.view:setVisible(false)
    self.curFrame = 0
end

function Bullet:setRotationGenerator(generator)
    -- 这个generator返回的是角速度
    self.rotationGenerator = generator
end

function Bullet:getView()
    return self.view
end

function Bullet:getBoomEffect()
    return self.boomEffect
end

function Bullet:update()
    if self.status==BulletConstants.BULLET_STATUS.READY then
        self.curFrame = self.curFrame + 1
        if self.trace:reach() then
            self:onReach()
            return
        end
        local targetPos = self.trace:getNextPos()
        if checkNodeExist(self:getView()) then
            self:getView():setPosition(targetPos)
            if self.rotationGenerator then
                self:getView():setRotation(self:getView():getRotation()+self.rotationGenerator:generate(self.curFrame))
            end
        end
        for _,trigger in ipairs(self.triggers) do
            trigger:update()
        end
        for _,sub in ipairs(self.subBullets) do
            sub:update()
        end
    end
end

function Bullet:getStatus()
    return self.status
end

function Bullet:ready()
    if self.status==BulletConstants.BULLET_STATUS.INIT then
        self.status = BulletConstants.BULLET_STATUS.READY
        self:getView():setVisible(true)
    end
end

function Bullet:onReach()
    self.status = BulletConstants.BULLET_STATUS.REACH
    self:getView():setVisible(false)
    local over = true
    if self.onBoomCallBack then
        self:onBoomCallBack()
    end
    if self.boomEffectCfg then
        local boomEffect = util.createEffectView(self.boomEffectCfg)
        if boomEffect then
            self.boomEffect = boomEffect
            over = false
            local view = self:getView()
            view:getParent():addChild(boomEffect, view:getLocalZOrder())
            boomEffect:setPosition(cc.p(view:getPosition()))
            boomEffect:registerSpineEventHandler(function()
                self.status = BulletConstants.BULLET_STATUS.OVER
            end, sp.EventType.ANIMATION_COMPLETE)
        end
    end
    if over then
        self.status = BulletConstants.BULLET_STATUS.OVER
    end
end

-- 子弹可以拥有自己的附属子弹,附属子弹一旦添加就一定会属于ready状态
function Bullet:addBullet(bullet, zOrder)
    bullet:ready()
    local view = bullet:getView()
    self:getView():addChild(view, zOrder or 0)
    table.insert(self.subBullets, bullet)
end

function Bullet:addTrigger(trigger)
    trigger:bind(self)
    table.insert(self.triggers, trigger)
end

return Bullet
