--[[
    作者：suchao@renrenche.com
    描述：调用auth系统获取用户权限信息
    时间：2018-12-22 10:19:00
]]
local octoc = require("conf.octo_conf")
local http = require("helper.http_client")
local octot = require("helper.token_generate")
local cjson = require "cjson"

---@class user_dao
user_dao = {_VERSION="0.1.0"};

--todo something
local const_request_url = octoc.server.."/auth/users/search";


---@see
---@private search
---@param condition table
---@return string
local function _search(condition)
    local url = const_request_url.."?_octo="..octot.get_jwt_token();
    local json_body = "{}";
    if condition ~= nil then
        json_body = cjson.encode(condition);
    end

    local content_type = "application/json;charset=utf-8"
    --获取用户权限
    res = http.post(url,json_body,content_type);
    if not res then
        return nil;
    end

    return res.body;
end

---@public get_user_info table
---@param user_id number
---@return string
function user_dao.get_user_info(user_id)
    local condition = {};
    condition["search"] = "id:"..user_id..";";
    condition["with"] = "roles.permissions;permissions;";
    condition["trashed"] = false;
    return _search(condition);
end


return user_dao;