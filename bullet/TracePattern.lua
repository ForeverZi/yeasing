local TraceFactory = import(".TraceFactory")
local Generator = import(".Generator")
local ExpEase = import(".ease.ExpEase")
local TracePattern = {}

function TracePattern.createMTYTrace(beginPos, endPos, index)
    index = index or 0
    local lengthGenerator = Generator.new({
        formula = function(x)
            return 7*x
        end,
    })
    local degreeGenerator = Generator.new({
        formula = function(x)
            local y = index*60+2*x
            return y
        end,
        inputRange = {0, 240},
    })
    local polarTrace = TraceFactory.createPolarTrace(beginPos, lengthGenerator, degreeGenerator, 30)
    polarTrace:addEase(ExpEase.new({frameRange={0,30}}))
    local stayTrace = TraceFactory.createLineTrace(polarTrace:getEndPos(), polarTrace:getEndPos(), 20)
    local lineTrace = TraceFactory.createLineTrace(stayTrace:getEndPos(), endPos, 20)
    lineTrace:addEase(ExpEase.new({frameRange={0,20}}))
    return TraceFactory.createCompositeTrace({polarTrace, stayTrace, lineTrace})
end

function TracePattern.createSpellTrace(beginPos, endPos, index)
    index = index or 0
    local polarFrame = 50
    local lengthGenerator = Generator.new({
        formula = function()
            return 200
        end,
    })
    local degreeGenerator = Generator.new({
        formula = function(x)
            local y = 360*index+10*x
            return y
        end,
        inputRange = {0, polarFrame},
    })
    degreeGenerator:addEase(ExpEase.new({frameRange={0,polarFrame}}))
    local polarTrace = TraceFactory.createPolarTrace(beginPos, lengthGenerator, degreeGenerator, polarFrame)
    polarTrace:addEase(ExpEase.new({frameRange={0,polarFrame}}))
    local lineTrace = TraceFactory.createLineTrace(polarTrace:getEndPos(), endPos, 10)
    lineTrace:addEase(ExpEase.new({frameRange={0,10}}))
    return TraceFactory.createCompositeTrace({polarTrace, lineTrace})
end

return TracePattern
