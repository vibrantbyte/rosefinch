--[[
    作者：suchao@renrenche.com
    描述：redis client tool
    时间：2018-12-22 10:19:00
]]
local redis = require("resty.redis")

---@class redis_client
redis_client = {}

--todo

---@public get_client
---
function redis_client.get_client()
    local red = redis:new();
    red:set_timeout(1000); -- 1sec

    --connect to server
    local ok,err = red:connect("973ce55e710f4e50.m.cnbja.kvstore.aliyuncs.com",6379);
    if not ok then
        ngx.say("failed to connect:",err);
        return;
    end

    --set authenticate
    local res,err = red:auth("xavYovNLzoxGy3zC");
    if not res then
        ngx.say("failed to authenticate:",err);
        return;
    end

    --select db
    red:select(0);

    return red;
end


return redis_client;