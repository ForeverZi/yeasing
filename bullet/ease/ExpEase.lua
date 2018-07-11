local Ease = import(".Ease")

local ExpEase = Ease.new({})

function ExpEase.new(params)
    local obj = {}
    setmetatable(obj, {__index=ExpEase})
    Ease.init(obj, params)
    obj:init(params)
    return obj
end

function ExpEase:init(params)
    self.params = params
    self.frameCount = self.frameRange[2]-self.frameRange[1]
    self.exp = math.exp(math.log(self.frameCount)/self.frameCount)
end

function ExpEase:getEaseFrame(curFrame)
    local base = self.frameRange[1]
    local delta = curFrame - base
    return base + math.pow(self.exp, delta)
end

return ExpEase
