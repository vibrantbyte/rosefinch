--[[
    作者：suchao@renrenche.com
    描述：octo configure
    时间：2018-12-22 10:19:00
]]
local conf = require("conf.conf");

octo_conf = {_VERSION="0.1.0"};

if conf.profile == "testing" then
    --key
    octo_conf.key = "";
    --secret
    octo_conf.secret = "";
    --server
    octo_conf.server = "";
    --expire 毫秒
    octo_conf.expire = 5000;
end

--返回配置信息
return octo_conf;

