--[[
    作者：suchao@renrenche.com
    描述：redis configure
    时间：2018-12-22 10:19:00
]]
local conf = require("conf.conf");

---@class redis_conf
redis_conf = {};

--default配置
redis_conf.default = "default";

function redis_conf.get_conf()
    --testing
    if conf.profile == "testing" then
        local config = {
            default = { -- your connection name
                host = '100.99.84.137',
                port = 6379,
                pass = "xavYovNLzoxGy3zC",
                timeout = 3000, -- millisecond watch out this value
                database = 0,
            }
        }
        return config;
    end


    --production


end

return redis_conf;