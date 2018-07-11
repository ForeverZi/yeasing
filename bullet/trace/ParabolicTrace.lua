local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

local ParabolicTrace = {}

function ParabolicTrace.new(params)
    local obj = {}
    setmetatable(obj, {__index=ParabolicTrace})
    obj:init(params)
    util.implement(obj, TraceInterface)
    return obj
end

function ParabolicTrace:init(params)
    self.beginPos = params.beginPos
    self.endPos = params.endPos
    self.frames = params.frames
    self.gravity = params.gravity

    self.curPos = cc.p(self.beginPos.x, self.beginPos.y)
    self.curFrame = 0
    self.speedX = (self.endPos.x - self.beginPos.x)/self.frames
    self.speedY = self.gravity*self.frames/2+(self.endPos.y-self.beginPos.y)/self.frames
end

function ParabolicTrace:getNextPos()
    self.curFrame = self.curFrame + 1
    local deltaFrame = self:getEaseFrame(self.curFrame)-self:getEaseFrame(self.curFrame-1)
    self.curPos = cc.p(self.curPos.x+self.speedX*deltaFrame, self.curPos.y+self.speedY*deltaFrame)
    self.speedY = self.speedY - self.gravity*deltaFrame
    return self.curPos
end

function ParabolicTrace:reach()
    return self.curFrame>=self.frames
end

function ParabolicTrace:getEndPos()
    return self.endPos
end

return ParabolicTrace
