local TraceInterface = {
    virtualMethods = {
        getNextPos = true,
        reach = true,
        getEndPos = true,
    },
}

function TraceInterface.new()
    local obj = {}
    setmetatable(obj, {__index=TraceInterface})
    return obj
end

function TraceInterface:getNextPos()
    error("virtual method")
end

function TraceInterface:reach()
    error("virtual method")
end

function TraceInterface:getEndPos()
    error("virtual method")
end

function TraceInterface:addEase(ease)
    assert(ease and ease.frameRange and ease.frameRange[1]>=0 and ease.frameRange[2]<=self.frames)
    self.easeList = self.easeList or {}
    table.insert(self.easeList, ease)
end

function TraceInterface:getEaseFrame(curFrame)
    for _,ease in ipairs(self.easeList or {}) do
        if ease:inRange(curFrame) then
            return ease:getEaseFrame(curFrame)
        end
    end
    return curFrame
end

return TraceInterface
