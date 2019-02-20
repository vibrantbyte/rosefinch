--[[
    作者：suchao@renrenche.com
    描述：white configure
    时间：2018-12-22 10:19:00
]]
---@class white_list
white_list = {}

--[[
    白名单列表存储
    建单说明：
        {}      ->  拥有全部权限；
        {""}    ->  没有任何权限；
        nil     ->  黑名单；
        {"SALESManager"}    -> 拥有SALESManager权限；
        1       ->  没有任何权限；
]]--
white_list["/v0/auth/users"] = {"SALESManager","BSALES","FIELDSALE","FIELDSALEManager","CHANNELFIELDSALE"};
white_list["/v0/auth/ucities"] = {"SALESManager","BSALES","FIELDSALE","CHANNELFIELDSALE","C1Manager"};
white_list["/v0/auth/test"] = {};       --设置全部权限，不做限制；
white_list["/v0/auth/test1"] = nil;
white_list["/v0/auth/test2"] = 1;
white_list["/v0/auth/test3"] = {""};    --没有设置任何权限；

--[[
    压测：
]]
white_list["/v0/auth/http/bench"] = {"C1Manager"};    --项目压测url；


-- 配置
white_list["/v1/auth/users/11"] = {};
white_list["/test/http/bench"] = {"SALESManager","BSALES","FIELDSALE","CHANNELFIELDSALE","C1Manager"};

--[[
-----------------------------------| 上面为白名单配置区 |-----------------------------------------
]]



---@private _empty_table 判断table是不是空
---@param tb table
---@return boolean
local function _empty_table(tb)
    return _G.next(tb) == nil;
end

---@public have_authority
---@param authority string
---@param url string
---@return boolean
function white_list.have_authority(authority,url)
    --[[
        nil: 黑名单
        other: 白名单
        返回结果: 拥有权限返回true;没有权限返回false;
    ]]
    --权限码如果为空，该用户没有任何权限；
    if authority == nil or authority == "" then
        return false;
    end

    --开始权限判断；
    local url_authority = white_list[url];
    if url_authority ~= nil and type(url_authority) == "table" then
        local contain = false;

        --判断是否具有所有权限，并返回；
        if _empty_table(url_authority) then
            contain = true;
            return contain;
        end

        --判断是包含权限
        for _,v in ipairs(url_authority) do
            if v == authority then
                contain = true;
                break;
            end
        end
        return contain;
    end
    --没有权限
    return false;
end


---@field match_logic table
white_list.match_logic = {};
white_list.match_logic.OR = 1;
white_list.match_logic.AND = 2;


---@public batch_have_authority
---@param authority_array table
---@param url
---@param logic number
---@return boolean
function white_list.batch_have_authority(authority_array,url,logic)
    --默认是 or
    if logic ~= white_list.match_logic.OR and logic ~= white_list.match_logic.AND then
        logic = white_list.match_logic.OR;
    end

    --判断权限是否为空
    if _empty_table(authority_array) then
        return false;
    end

    local url_authority = white_list[url];
    if url_authority ~= nil and type(url_authority) == "table" then

        --判断是否具有所有权限，并返回；
        if _empty_table(url_authority) then
            return true;
        end

        --[[
            使用map解决查找问题
        ]]
        local map_contain = {};
        for _,v in ipairs(url_authority) do
            map_contain[v] = true;
        end

        --or 处理逻辑
        if logic == white_list.match_logic.OR then
            local result = false;
            for _,v in ipairs(authority_array) do
                if map_contain[v] then
                    result = true;
                    break;
                end
            end
            return result;
        end

        --and 处理逻辑
        if logic == white_list.match_logic.AND then
            local result = true;
            for _,v in ipairs(authority_array) do
                if not map_contain[v] then
                    result = false;
                    break;
                end
            end
            return result;
        end
    end

    return false;
end

return white_list;