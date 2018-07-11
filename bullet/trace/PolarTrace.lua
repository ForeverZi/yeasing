local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

local PolarTrace = {}

function PolarTrace.new(params)
    local obj = {}
    setmetatable(obj, {__index=PolarTrace})
    obj:init(params)
    util.implement(obj, TraceInterface)
    return obj
end

function PolarTrace:init(params)
    self.lengthGenerator = params.lengthGenerator
    self.degreeGenerator = params.degreeGenerator
    self.origin = params.origin
    self.frames = params.frames
    self.curFrame = 0
end

function PolarTrace:getNextPos()
    self.curFrame = self.curFrame + 1
    local easeFrame = self:getEaseFrame(self.curFrame)
    return self:getFramePos(easeFrame)
end

function PolarTrace:reach()
    return self.curFrame>=self.frames
end

function PolarTrace:getFramePos(curFrame)
    local length = self.lengthGenerator:generate(curFrame)
    local degree = self.degreeGenerator:generate(curFrame)
    local rad = math.rad(degree)
    local framePos = cc.p(self.origin.x + length*math.cos(rad), self.origin.y + length*math.sin(rad))
    return framePos
end

function PolarTrace:getEndPos()
    return self:getFramePos(self.frames)
end

return PolarTrace
