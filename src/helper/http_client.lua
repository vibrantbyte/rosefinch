--[[
    作者：suchao@renrenche.com
    描述：http client tool
    时间：2018-12-22 10:19:00
]]
local http = require "resty.http"

---@class http_client
http_client = {_VERSION="0.1.0"};

---@field private default_content_type string
local default_content_type = "application/x-www-form-urlencoded;charset=utf-8";

---@public get table
---@param url string
---@param content_type string
---@return table
function http_client.get(url,content_type)
    if content_type ~= nil then
        default_content_type = content_type;
    end
    ---@field private httpc table
    local httpc = http.new()
    ---@type table
    local res, err = httpc:request_uri(url, {
        method = "GET",
        headers = {
            ["Content-Type"] = default_content_type,
        },
        keepalive_timeout = 60,
        keepalive_pool = 10
    })

    if not res then
        ngx.say("failed to request: ", err)
        return nil
    end

    return res
end

---@public post table
---@param url string
---@param request_body string
---@param content_type string
---@return table
function http_client.post(url,request_body,content_type)
    if content_type ~= nil then
        default_content_type = content_type;
    end
    local httpc = http.new()

    local res, err = httpc:request_uri(url, {
        method = "POST",
        body = request_body,
        headers = {
            ["Content-Type"] = default_content_type,
        },
        keepalive_timeout = 60,
        keepalive_pool = 10
    })

    if not res then
        ngx.say("failed to request: ", err)
        return nil;
    end

    return res;
end


return http_client;
