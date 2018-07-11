local Ease = import(".Ease")

local AccEase = Ease.new({})

function AccEase.new(params)
    local obj = {}
    setmetatable(obj, {__index=AccEase})
    Ease.init(obj, params)
    obj:init(params)
    return obj
end

function AccEase:init(params)
    self.params = params
    self.frameCount = self.frameRange[2]-self.frameRange[1]
    self.acc = 2/self.frameCount
end

function AccEase:getEaseFrame(curFrame)
    local base = self.frameRange[1]
    local delta = curFrame - base
    return base + self.acc*(delta^2)/2
end

return AccEase
