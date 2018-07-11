local Trace = import(".trace.Trace")
local FollowTrace = import(".trace.FollowTrace")
local BezierTrace = import(".trace.BezierTrace")
local PolarTrace = import(".trace.PolarTrace")
local ParabolicTrace = import(".trace.ParabolicTrace")
local MockParabolicTrace = import(".trace.MockParabolicTrace")
local CompositeTrace = import(".trace.CompositeTrace")

local TraceFactory = {}

function TraceFactory.createCompositeTrace(traceList)
    local trace = CompositeTrace.new(traceList)
    return trace
end

function TraceFactory.createLineTrace(beginPos, endPos, frames)
    local trace = Trace.new({
        beginPos = beginPos,
        endPos = endPos,
        frames = frames
    })
    return trace
end

function TraceFactory.createFollowTrace(beginPos, target, frames)
    local trace = FollowTrace.new({
        beginPos = beginPos,
        target = target,
        frames = frames
    })
    return trace
end

function TraceFactory.createBezierTrace(tracePoints, frames, target)
    local trace = BezierTrace.new({
        tracePoints = tracePoints,
        frames = frames,
        target = target,
    })
    return trace
end

function TraceFactory.createPolarTrace(origin, lengthGenerator, degreeGenerator, frames)
    local trace = PolarTrace.new({
        origin = origin,
        lengthGenerator = lengthGenerator,
        degreeGenerator = degreeGenerator,
        frames = frames,
    })
    return trace
end

function TraceFactory.createParabolicTrace(beginPos, endPos, gravity,frames)
    local trace = ParabolicTrace.new({
        beginPos = beginPos,
        endPos = endPos,
        frames = frames,
        gravity = gravity,
    })
    return trace
end

function TraceFactory.createMockParabolicTrace(beginPos, endPos, gravity,frames)
    local trace = MockParabolicTrace.new({
        beginPos = beginPos,
        endPos = endPos,
        frames = frames,
        gravity = gravity,
    })
    return trace
end


return TraceFactory
