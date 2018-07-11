local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

local BezierTrace = {}

function BezierTrace.new(params)
    local obj = {}
    setmetatable(obj, {__index=BezierTrace})
    obj:init(params)
    util.implement(obj, TraceInterface)
    return obj
end

function BezierTrace:init(params)
    assert(params.tracePoints and #params.tracePoints>=3)
    self.tracePoints = params.tracePoints
    self.frames = params.frames
    self.target = params.target
    if self.target then
        self.endPos = cc.p(self.target:getPosition())
    else
        self.endPos = self.tracePoints[#self.tracePoints]
    end
    self.curFrame = 0
    self.progress = 0
end

function BezierTrace:getNextPos()
    self.curFrame = self.curFrame + 1
    local easeFrame = self:getEaseFrame(self.curFrame)
    self.progress = easeFrame/self.frames
    local tracePoints = self.tracePoints
    while #tracePoints>1 do
        local newBezierTrace = {}
        for i=1,#tracePoints-1 do
            local pa = tracePoints[i]
            local pb = tracePoints[i+1]
            table.insert(newBezierTrace, self:getLineScalePoint(pa, pb, self.progress))
        end
        tracePoints = newBezierTrace
    end
    local nextPos = tracePoints[1]
    if self.target then
        local curEndPos = cc.p(self.target:getPosition())
        nextPos = cc.p(nextPos.x+(curEndPos.x-self.endPos.x), nextPos.y+(curEndPos.y-self.endPos.y))
        self.endPos = curEndPos
    end
    return nextPos
end

function BezierTrace:reach()
    return self.curFrame>=self.frames
end

function BezierTrace:getLineScalePoint(a, b, scale)
    local delta = cc.p(b.x-a.x, b.y-a.y)
    local p = cc.p(a.x+delta.x*scale, a.y+delta.y*scale)
    return p
end

function BezierTrace:getEndPos()
    return self.endPos
end

return BezierTrace
