local util = import("..BulletUtil")
local TraceInterface = import(".TraceInterface")

local CompositeTrace = {}

function CompositeTrace.new(traceList)
    local obj = {}
    setmetatable(obj, {__index=CompositeTrace})
    obj:init(traceList)
    util.implement(obj, TraceInterface)
    return obj
end

function CompositeTrace:init(traceList)
    assert(traceList and #traceList>0)
    self.traceList = traceList
end

function CompositeTrace:getCurTrace()
    for _,v in ipairs(self.traceList) do
        if not v:reach() then
            return v
        end
    end
end

function CompositeTrace:getNextPos()
    local nextPos = self:getCurTrace():getNextPos()
    return nextPos
end

function CompositeTrace:reach()
    return self.traceList[#self.traceList]:reach()
end

function CompositeTrace:getEndPos()
    return self.traceList[#self.traceList]:getEndPos()
end

return CompositeTrace
