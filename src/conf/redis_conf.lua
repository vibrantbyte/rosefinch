--[[
    作者：suchao@renrenche.com
    描述：redis configure
    时间：2018-12-22 10:19:00
]]
---@class redis_conf
redis_conf = {};

--default配置
redis_conf.default = "default";

function redis_conf.get_conf()

    if _PROFILE == "debug" then
        --debug 环境
        local config = {
            default = { -- your connection name
                host = '100.99.84.137',
                port = 6379,
                pass = "123456",
                timeout = 3000, -- millisecond watch out this value
                database = 0,
            }
        }
        --返回配置
        return config;
    elseif _PROFILE == "testing" then
        --testing 环境
        local config = {
            default = { -- your connection name
                host = '100.99.84.137',
                port = 6379,
                pass = "123456",
                timeout = 3000, -- millisecond watch out this value
                database = 0,
            }
        }
        --返回配置
        return config;
    elseif _PROFILE == "production" then
        --production 环境

    end
    return nil;
end

return redis_conf;