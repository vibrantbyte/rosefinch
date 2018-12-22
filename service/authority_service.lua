--[[
    作者：suchao@renrenche.com
    描述：权限 生成 toke 服务
    时间：2018-12-22 10:19:00
]]
local user = require("octo.auth.user_dao")
local cjson = require("cjson");
local mas_service = require("service.mas_service");
local redis_service = require("service.redis_service");
local table_helper = require("helper.table_helper");
local white_list = require("conf.white_list_conf");
local utime = require "helper.time_helper";
local response_error = require("helper.response_error");

---@class authority_service
authority_service = {};

---@public get_user_authority
---@param user_id number
---@return table
function authority_service.get_user_authority(user_id)
    local str_body = user.get_user_info(user_id);
    return cjson.decode(str_body);
end


---@private ngx_cache
---@param token string
---@return string
local function ngx_cache(token)
    --[[
        将用户信息存在再user_cache域中；
        return string,table
    ]]

    --如果key不存在初始化成table
    if ngx.shared.ngx_cache.user_cache == nil then
        ngx.shared.ngx_cache.user_cache = {};
    end

    --user_cache 作为元表
    local cache = {};
    setmetatable(cache,{ __index = ngx.shared.ngx_cache.user_cache})

    --只操作user，通过设置__index来查找元表,__newindex来写入元表
    local user_info = cache[token];
    if user_info == nil or user_info == "" then
        return nil;
    end
    return user_info;
end

---@private set_ngx_cache
---@param token string
---@return nil
local function set_ngx_cache(token,json)
    --[[
        将用户信息存在再user_cache域中；
        return string,table
    ]]
    --如果key不存在初始化成table
    if ngx.shared.ngx_cache.user_cache == nil then
        ngx.shared.ngx_cache.user_cache = {};
    end

    --user_cache 作为元表
    local cache = {};
    setmetatable(cache,{ __newindex = ngx.shared.ngx_cache.user_cache})

    --只操作user，通过设置__index来查找元表,__newindex来写入元表
    cache[token] = json;
end

---@private redis_cache
---@param token string
---@return string
local function redis_cache(token)
    --redis key
    local key = redis_service.prefix_user_authority..token;
    local user_info = redis_service.get(key);
    if user_info == nil or user_info == "" then
        return nil
    end
    return user_info;
end


---@private redis_cache
---@param token string
---@param value string
---@return boolean
local function set_redis_cache(token,value)
    --redis key
    local key = redis_service.prefix_user_authority..token;
    redis_service.set(key,value);
    --获取当天24点
    redis_service.expire_at(key,utime.get_today_over());
end

---@public verify_user_authority
---@param url string
---@param token string
---@return table
function authority_service.verify_user_authority(url,token)
    -- 返回是否通过和错误信息
    --[[
        处理具体逻辑：
        1、判断直接内存中对否存在该对象，如果如果存在，获取权限；
        2、如果不存在从redis中获取权限；
        3、如果都不存在，开始进行token解析，得到userId；
        4、通过userId获取用户详细信息，主要是权限数据；
        5、通过配置验证权限；
        6、开始协程刷新直接缓存和redis缓存；
    ]]
    local response = response_error:new();

    local user_table = {};

    --获取用户缓存对象（一级缓存）
    local user = ngx_cache(token);
    if user == nil then
        --读取redis用户缓存数据(二级缓存)
        user = redis_cache(token);
        if user == nil or user == ngx.null then
            --进行token解析
            local body = mas_service.verify(token);
            if body.status == 0 then
                local data = body.data;
                local user_detail_list = authority_service.get_user_authority(data.userId);
                if table_helper.empty_table(user_detail_list) then
                    return response:generate_error(401,"auth 系统获取用户列表为空！");
                end
                local user_detail = user_detail_list[1]; --lua 数组从1开始；
                user_table["id"] = user_detail.user_id;
                user_table["name"] = user_detail.name;
                user_table["role"] = user_detail.role;
                ngx.print(cjson.encode(user_table))
                -- 获取用户角色或权限码
                local roles = user_detail.roles;
                local authority_array = {};
                local index = 0;
                if roles then
                    for _, v in pairs(roles) do
                        index = index + 1;
                        authority_array[index] = v.title;
                    end
                    --初始化权限
                    user_table["authority_array"] = authority_array;
                    local json = cjson.encode(user_table);
                    --设置用户缓存(一级缓存)
                    set_ngx_cache(token,json);
                    --设置用户redis(二级缓存)
                    set_redis_cache(token,json);
                end
            else
                return response:generate(body);
            end
        end
    end

    --当缓存存在的时候
    if user ~= nil and user ~= "" then
        if not pcall(function (_user)
            user_table = cjson.decode(_user);
        end,user) then
            return response:generate_error(401,"cjson 转换成 json data失败！");
        end
    end

    --缓存和auth系统都不存在的时候；
    if table_helper.empty_table(user_table) then
        return response:generate_error(404,"缓存和Auth系统中同时不存在该用户！");
    end

    --判断是否通过权限验证；
    if white_list.batch_have_authority(user_table.authority_array,url,white_list.match_logic.OR) then
        return response:generate({});
    else
        return response:generate_error(401,"您没有权限访问该接口！");
    end
end

return authority_service;