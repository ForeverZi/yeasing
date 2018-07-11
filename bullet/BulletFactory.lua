local Bullet = import(".Bullet")
local TraceFactory = import(".TraceFactory")
-- local Trigger = import(".trigger.Trigger")
local FONT = require "utils.Locale".getDefaultFont()

local BulletFactory = {}

function BulletFactory.createBullet(view, trace, boomEffectCfg, onBoomCallBack)
    return Bullet.new({
        view = view,
        trace = trace,
        boomEffectCfg = boomEffectCfg,
        onBoomCallBack = onBoomCallBack,
    })
end

local COLORS = {
    cc.c4b(0xff, 0x5e, 0x5f, 255),
    cc.c4b(0x88, 0xff, 0x71, 255),
    cc.c4b(0x38, 0xce, 0xff, 255),
    cc.c4b(0xff, 0x8c, 0x5f, 255),
}

function BulletFactory.createSpellBullets(msgs, count, direction, delay, duration, spellItemWidth)
    local bullets = {}
    local slotsRec = {}
    local heightRange = 720-156
    local sampleText = cc.Label:createWithTTF(msgs[1], FONT, 28)
    for slotId=1, math.floor(heightRange/sampleText:getContentSize().height) do
        table.insert(slotsRec, slotId)
    end
    local slotHeight = heightRange/#slotsRec
    count = math.min(count, #slotsRec)
    for i=1,count do
        local index = i
        while index>#msgs do
            index  = index - #msgs
        end
        local withColor = math.random()<=0.3
        local color = withColor and COLORS[math.random(1,4)] or FONT_COLOR_WHITE
        local text = cc.Label:createWithTTF(msgs[index], FONT, 28)
        text:setTextColor(color)
        text:enableOutline(FONT_COLOR_BLACK, 1)
        local slotIndex  = math.random(1, #slotsRec)
        local slotId = slotsRec[slotIndex]
        table.remove(slotsRec, slotIndex)
        local beginPos, endPos
        local delta = math.random(1,100)/100*spellItemWidth + text:getContentSize().width
        if direction==1 then
            text:setAnchorPoint(cc.p(1, 0))
            beginPos = cc.p(0,
                78+(slotId-1)*slotHeight)
            endPos = cc.p(1280+delta, beginPos.y)
        else
            text:setAnchorPoint(cc.p(0, 0))
            beginPos = cc.p(1280,
                78+(slotId-1)*slotHeight)
            endPos = cc.p(-delta, beginPos.y)
        end
        local bullet
        local delayTrace = TraceFactory.createLineTrace(beginPos, beginPos, delay)
        local trace
        local lineDuration = duration+10
        if withColor then
            lineDuration = lineDuration*0.9
        end
        if i==1 then
            trace = TraceFactory.createLineTrace(beginPos, endPos, lineDuration)
            bullet = BulletFactory.createBullet(text, TraceFactory.createCompositeTrace({delayTrace, trace}))
        else
            trace = TraceFactory.createLineTrace(beginPos, endPos, lineDuration)
            bullet = BulletFactory.createBullet(text, TraceFactory.createCompositeTrace({delayTrace, trace}))
        end
        bullet:ready()
        table.insert(bullets, bullet)
    end
    return bullets
end

return BulletFactory
