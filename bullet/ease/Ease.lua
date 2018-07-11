local Ease = {}

function Ease.new(params)
    local obj = {}
    setmetatable(obj, {__index=Ease})
    obj:init(params)
    return obj
end

function Ease:init(params)
    --闭区间,必须在trace的frame区间内
    self.frameRange = params.frameRange
end

function Ease:inRange(curFrame)
    return curFrame>=self.frameRange[1] and curFrame<=self.frameRange[2]
end

function Ease:getEaseFrame(curFrame)
    return curFrame
end

return Ease
