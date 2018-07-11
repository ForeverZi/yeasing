local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

local Trace = {}

function Trace.new(params)
    local obj = {}
    setmetatable(obj, {__index=Trace})
    obj:init(params)
    util.implement(obj, TraceInterface)
    return obj
end

function Trace:init(params)
    self.beginPos = params.beginPos
    self.endPos = params.endPos
    self.frames = params.frames
    self.curFrame = 0
    self.delta = cc.p((self.endPos.x-self.beginPos.x)/self.frames,
        (self.endPos.y-self.beginPos.y)/self.frames)
end

function Trace:getNextPos()
    self.curFrame = self.curFrame + 1
    local easeFrame = self:getEaseFrame(self.curFrame)
    local nextPos = cc.p(self.beginPos.x+easeFrame*self.delta.x,
        self.beginPos.y+easeFrame*self.delta.y)
    return nextPos
end

function Trace:reach()
    return self.curFrame>=self.frames
end

function Trace:getEndPos()
    return self.endPos
end

return Trace
