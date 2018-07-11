local BulletConstants = import(".BulletConstants")
local BulletUtil = {}

function BulletUtil.implement(obj, interface)
    assert(obj and interface)
    for k,v in pairs(interface) do
        if type(v)=="function" then
            if interface.virtualMethods[k] then
                assert(type(obj[k])=="function", string.format("方法%s未实现", k))
            elseif (not obj[k]) or type(obj[k])~="function" then
                obj[k] = v
            end
        end
    end
end

local BULLET_RES = {
    IMAGE = "bullet/image/",
    ANIM = "bullet/anim/",
    PARTICLE = "bullet/particle/",
    SPINE = "bullet/spine/",
}

function BulletUtil.createEffectView(res)
    local view
    local v = string.toArray(res,"=")
    if #v >= 2 then
        local resType = tonumber(v[1])
        local fileName = v[2]
        if fileName then
            local x,y = tonumber(v[3]) or 0,tonumber(v[4]) or 0
            if resType==BulletConstants.RES_TYPE.IMAGE then --图片
                local path = string.format("%s%s.png", BULLET_RES.IMAGE, fileName)
                local sprite = display.newSprite(path)
                sprite:setAnchorPoint(cc.p(0.5,0))
                sprite:pos(x,y)
                view = sprite
            elseif resType==BulletConstants.RES_TYPE.ANIM then --帧动画
                x,y = tonumber(v[5]) or 0,tonumber(v[6]) or 0
                local animation = display.getAnimationCache(fileName)
                if animation == nil then
                    local length,fps = tonumber(v[3]),tonumber(v[4])
                    local path = string.format("%s%s", BULLET_RES.ANIM, fileName)
                    display.addSpriteFrames(path .. ".plist",path .. ".png")
                    local frames = display.newFrames(fileName.."_%02d.png", 1, length)
                    animation = display.newAnimation(frames, 1/fps)
                end
                view = display.newSprite():pos(x,y):playAnimationForever(animation)
            elseif resType==BulletConstants.RES_TYPE.PARTICLE then --粒子
                local particle = cc.ParticleSystemQuad:create(string.format("%s%s.plist", BULLET_RES.PARTICLE, fileName))
                particle:pos(x,y)
                view = particle
            elseif resType==BulletConstants.RES_TYPE.SPINE then --骨骼动画
                local path = string.format("%s%s", BULLET_RES.SPINE, fileName)
                local spine = sp.SkeletonAnimation:create(path..".skel",path ..".atlas",1)
                spine:pos(x, y)
                local animName = v[5] or "animation"
                spine:setAnimation(0, animName, true)
                view = spine
            end
        end
    end
    return view
end

return BulletUtil
