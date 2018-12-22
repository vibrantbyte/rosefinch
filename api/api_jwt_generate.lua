--[[
    作者：suchao@renrenche.com
    描述：jwt service
    时间：2018-12-22 10:19:00
]]
local jwt_service = require("service.jwt_service");


ngx.header.content_type = "text/plain";
ngx.say(jwt_service.get_jwt_token());

--if jit then
--    ngx.say('luajit:' .. jit.version)
--else
--    ngx.say('lua:'.._VERSION)
--end
