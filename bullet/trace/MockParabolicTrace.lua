local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

-- 我们将起始点和终点所在直线作为x轴，垂直该直线的为y轴模拟抛物线
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
    local line = cc.p(self.endPos.x-self.beginPos.x, self.endPos.y-self.beginPos.x)
    -- gravityVector都是垂直向上分量
    if line.y~=0 then
        local gx = self.gravity*math.sqrt(1+(line.x/line.y)^2)
        local gy = (-line.x/line.y)*gx
        gx = gy>0 and gx or -gx
        gy = math.abs(gx)
        self.gravityVector = cc.p(gx, gy)
    else
        self.gravityVector = cc.p(0, self.gravity)
    end
    self.curFrame = 0
    self.speedX = (self.endPos.x - self.beginPos.x)/self.frames + self.gravityVector.x*self.frames/2
    self.speedY = (self.endPos.y - self.beginPos.y)/self.frames + self.gravityVector.y*self.frames/2
end

function ParabolicTrace:getNextPos()
    self.curFrame = self.curFrame + 1
    local deltaFrame = self:getEaseFrame(self.curFrame)-self:getEaseFrame(self.curFrame-1)
    self.curPos = cc.p(self.curPos.x + self.speedX*deltaFrame, self.curPos.y + self.speedY*deltaFrame)
    self.speedX = self.speedX - self.gravityVector.x*deltaFrame
    self.speedY = self.speedY - self.gravityVector.y*deltaFrame
    return self.curPos
end

function ParabolicTrace:reach()
    return self.curFrame>=self.frames
end

function ParabolicTrace:getEndPos()
    return self.endPos
end

return ParabolicTrace
