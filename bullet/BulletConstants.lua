local BulletConstants = {

    BULLET_STATUS = {
        INIT = 0, --创建
        READY = 1, --准备
        REACH = 2, --到达
        OVER = 3, --完成
    },

    RES_TYPE = {
        IMAGE = 1,
        ANIM = 2,
        PARTICLE = 3,
        SPINE = 4,
    },

    BULLET_Z_ORDER = {
        TOP = 100000,
        BOTTOM = 1,
    }

}

return BulletConstants
