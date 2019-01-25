--[[
    作者：suchao@renrenche.com
    描述：mas conf
    时间：2018-12-22 10:19:00
]]
local conf = require("conf.conf");

mas_conf = {_VERSION="0.1.0"};

if conf.profile == "testing" then
    mas_conf.server = "";
    mas_conf.path = "/token/verify";
end

--返回配置信息
return mas_conf;