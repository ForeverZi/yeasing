local TraceInterface = import(".TraceInterface")
local util = import("..BulletUtil")

local FollowTrace = {}

function FollowTrace.new(params)
    local obj = {}
    setmetatable(obj, {__index=FollowTrace})
    obj:init(params)
    util.implement(obj, TraceInterface)
    return obj
end

function FollowTrace:init(params)
    self.beginPos = params.beginPos
    self.target = params.target
    self.frames = params.frames
    self.endPos = cc.p(self.target:getPosition())
    self.curFrame = 0
    self.delta = cc.p((self.endPos.x-self.beginPos.x)/self.frames,
        (self.endPos.y-self.beginPos.y)/self.frames)
end

function FollowTrace:getNextPos()
    self.curFrame = self.curFrame + 1
    local easeFrame = self:getEaseFrame(self.curFrame)
    -- 如果追踪的目标失踪了，则使用目标最近的位置
    local curTargetPos = checkNodeExist(self.target) and cc.p(self.target:getPosition())
        or self.endPos
    local nextX = self.beginPos.x + self.delta.x*easeFrame + curTargetPos.x-self.endPos.x
    local nextY = self.beginPos.y + self.delta.y*easeFrame + curTargetPos.y-self.endPos.y
    self.endPos = curTargetPos
    return cc.p(nextX, nextY)
end

function FollowTrace:reach()
    return self.curFrame>=self.frames
end

function FollowTrace:getEndPos()
    return self.endPos
end

return FollowTrace
