--[[
    作者：suchao@renrenche.com
    描述：生成 token值
    时间：2018-12-22 10:19:00
]]
local conf = require("src.conf.octo_conf");
local jwt = require "resty.jwt";
local utime = require "src.helper.time_helper"
--token generate class
token_generate = { _VERSION="0.1.0"};


function token_generate.get_jwt_token()
    local millisecond = utime.current_time_millis();
    local token = jwt:sign(conf.secret,{
        header={typ="JWT", alg="HS256"},
        payload={iss=conf.key, iat=millisecond, nbf=millisecond, exp=millisecond+conf.expire}
    });
    return token;
end

return token_generate;