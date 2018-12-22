--[[
    作者：suchao@renrenche.com
    描述：jwt 生成 toke 服务
    时间：2018-12-22 10:19:00
]]
local token_generate = require("helper.token_generate");

jwt_service = {_VERSION="0.1.0"};

-- 通过token生成服务进行token的生成
function jwt_service.get_jwt_token()
    return token_generate.get_jwt_token();
end

return jwt_service;