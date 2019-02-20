--[[
    作者：suchao@renrenche.com
    描述：mas 服务
    时间：2018-12-22 10:19:00
]]
local http = require("src.helper.http_client")
local confm = require("src.conf.mas_conf")

mas_service = {};

---@public verify
---@param token string
---@return table
function mas_service.verify(token)
    local request_url = confm.server..confm.path.."?token="..token;
    res = http.get(request_url,nil);
    if not res then
        return conf.fault_response;
    end

    local str_response = res.body;
    return cjson.decode(str_response);
end

return mas_service;