--[[
    作者：suchao@renrenche.com
    描述：mas conf
    时间：2018-12-22 10:19:00
]]
mas_conf = {_VERSION="0.1.0"};

if _PROFILE == "debug" then
    --debug 环境
    mas_conf.server = "http://101.200.184.102:7777";
    mas_conf.path = "/token/verify";


elseif _PROFILE == "testing" then
    --testing 环境
    mas_conf.server = "http://101.200.184.102:7777";
    mas_conf.path = "/token/verify";

elseif _PROFILE == "production" then
    --production 环境

end

--返回配置信息
return mas_conf;