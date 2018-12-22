---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2018/12/21 下午6:00
---


local redis_conf = require("conf.redis_conf");

ngx.header.content_type = "text/plain";
-- config example
local config = {
    redis_a = { -- your connection name
        host = '100.99.84.137',
        port = 6379,
        pass = "xavYovNLzoxGy3zC",
        timeout = 200, -- watch out this value
        database = 0,
    },
    redis_b = {
        host = '100.99.84.137',
        port = 6379,
        pass = "xavYovNLzoxGy3zC",
        timeout = 200,
        database = 0,
    },
}

local redis_factory = require('helper.redis_factory')(redis_conf.get_conf()) -- import config when construct


function test_get_redis()

    local ok, redis_a = redis_factory:get_instance(redis_conf.default)

    local ok = redis_a:set('test', "aaaaaaaaaaa")
    if not ok then ngx.say("failed") end
    ngx.print(redis_a:get("test"));

    redis_factory:destruct() -- important, better call this method on your main function return

    ngx.say("end")
end


test_get_redis();