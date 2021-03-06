---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2018/12/23 上午10:20
---
-- 如果想要进行远程调试请加上_DEBUG；
_DEBUG();
--权限验证阶段
local table_helper = require("src.helper.table_helper");
local authority_service = require("src.service.authority_service");
local response_error = require("src.helper.response_error");

--请求进入初始化
local response= response_error:new();
--[[
    权限判断 app-api
]]
local request_args_tab = ngx.req.get_uri_args();
--1、参数为空 直接返回没有权限
if table_helper.empty_table(request_args_tab) then
    ngx.status = ngx.HTTP_UNAUTHORIZED;
    ngx.print(cjson.encode(response:generate_error(401,"uri参数中没有设置app_token！")));
    return;
end

--2、判断参数中是否包含app_token
local app_token = request_args_tab["app_token"];
if app_token == nil or app_token == "" then
    ngx.status = ngx.HTTP_UNAUTHORIZED;
    ngx.print(cjson.encode(response:generate_error(401,"uri参数中没有设置app_token！")));
    return;
end

--3、进行mas校验返回用户权限；
local uri = ngx.var.uri;
local result = authority_service.verify_user_authority(uri,app_token);
if result.status ~= 0 then
    ngx.status = ngx.HTTP_UNAUTHORIZED;
    ngx.print(cjson.encode(result));
    return;
end
