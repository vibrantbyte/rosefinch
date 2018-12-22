--[[
    作者：suchao@renrenche.com
    描述：auth api controller
    时间：2018-12-22 10:19:00
]]
local jwt_service = require("service.jwt_service");
local conf = require("conf.octo_conf");
local string = require("string");
local table_helper = require("helper.table_helper");
local authority_service = require("service.authority_service");
local cjson = require("cjson");


ngx.header.content_type = "text/plain";

--[[
    权限判断 app-api
]]
local request_args_tab = ngx.req.get_uri_args();
--1、参数为空 直接返回没有权限
if table_helper.empty_table(request_args_tab) then
    ngx.print(cjson.encode(common_error.token_error));
    return;
end

--2、判断参数中是否包含app_token
local app_token = request_args_tab["app_token"];
if app_token == nil or app_token == "" then
    ngx.print(cjson.encode(common_error.token_error));
    return;
end

--3、进行mas校验返回用户权限；
local uri = ngx.var.uri;
local result = authority_service.verify_user_authority(uri,app_token);
if result.status ~= 0 then
    ngx.print(cjson.encode(result));
    return;
end


--4、进行代理 a、octo—token生成
local path = "/v0/auth"
local request_uri = ngx.var.request_uri;
local target_uri = string.sub(request_uri,string.len(path) + 1);
local proxy_addr =conf.server.."/auth";
local url  = proxy_addr..target_uri;

--set token
ngx.req.set_header("Authorization", "Bearer "..jwt_service.get_jwt_token());

--4、进行代理 a、代理连接
local res = ngx.location.capture('/internet_proxy',
        {
            args = {url = url },
            copy_all_vars = true
        }
)

--5、返回代理response
ngx.print(res.body)
