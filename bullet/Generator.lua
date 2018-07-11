-- 单变量的值生成器
local Generator = {}

function Generator.new(params)
    local obj = {}
    setmetatable(obj, {__index=Generator})
    obj:init(params)
    return obj
end

function Generator:init(params)
    -- 范围是一个数组，含有两个数字，并且range[1]<=range[2]
    self.inputRange = params.inputRange
    self.outputRange = params.outputRange
    -- 公式是一个函数，输入一个参数，输出一个数
    self.formula = params.formula
end

function Generator:generate(x)
    x = self:limitInput(x)
    x = self:getEaseFrame(x)
    local value = self.formula(x)
    value = self:limitOutput(value)
    return value
end

function Generator:outOfInputRange(x)
    if self.inputRange then
        local floor = self.inputRange[1]
        if floor and x<floor then
            return true
        end
        local ceil = self.inputRange[2]
        if ceil and x>ceil then
            return true
        end
    end
    return false
end

function Generator:limitInput(value)
    if self.inputRange then
        local floor = self.inputRange[1]
        if floor then
            value = math.max(floor, value)
        end
        local ceil = self.inputRange[2]
        if ceil then
            value = math.min(ceil, value)
        end
    end
    return value
end

function Generator:limitOutput(value)
    if self.outputRange then
        local floor = self.outputRange[1]
        if floor then
            value = math.max(floor, value)
        end
        local ceil = self.outputRange[2]
        if ceil then
            value = math.min(ceil, value)
        end
    end
    return value
end

function Generator:addEase(ease)
    assert(ease and ease.frameRange and self.inputRange and self.inputRange[1] and
        ease.frameRange[1]>=self.inputRange[1] and self.inputRange[2] and ease.frameRange[2]<=self.inputRange[2])
    self.easeList = self.easeList or {}
    table.insert(self.easeList, ease)
end

function Generator:getEaseFrame(curFrame)
    for _,ease in ipairs(self.easeList or {}) do
        if ease:inRange(curFrame) then
            return ease:getEaseFrame(curFrame)
        end
    end
    return curFrame
end

return Generator
