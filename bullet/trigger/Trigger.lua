local Trigger = {}

function Trigger.new(params)
    local obj = {}
    setmetatable(obj, {__index=Trigger})
    obj:init(params)
    return obj
end

function Trigger:init(params)
    self.curFrame = 0
    self.curTriggerTimes = 0
    self.triggerTimes = params.triggerTimes or 1 --默认一次
    --一个返回布尔值，输入bullet的函数
    self.condition = params.condition
    self.callback = params.callback
end

function Trigger:bind(bullet)
    self.bullet = bullet
end

function Trigger:update()
    self.curFrame = self.curFrame + 1
    self:trigger()
end

function Trigger:trigger()
    if self.curTriggerTimes<self.triggerTimes and self:satisfyConditions() then
        self:onTriggered()
    end
end

function Trigger:satisfyConditions()
    -- 规则待定
    if self.condition and type(self.condition)=="function" then
        return self.condition(self.bullet)
    end
    return false
end

function Trigger:onTriggered()
    self.curTriggerTimes = self.curTriggerTimes + 1
    if self.callback then
        self.callback(self.bullet, self.curFrame, self.curTriggerTimes)
    end
end

return Trigger
