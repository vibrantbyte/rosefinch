--[[
    作者：suchao@renrenche.com
    描述：octo configure
    时间：2018-12-22 10:19:00
]]
octo_conf = {_VERSION="0.1.0"};

if _PROFILE == "debug" then
    --debug 环境
    --key
    octo_conf.key = "f550044384694e9380db229b1730c425";
    --secret
    octo_conf.secret = "ef4d0fc9bd924f389217ad409f584af5";
    --server
    octo_conf.server = "http://10.165.126.103:8000";
    --expire 毫秒
    octo_conf.expire = 5000;


elseif _PROFILE == "testing" then
    --testing 环境
    --key
    octo_conf.key = "f550044384694e9380db229b1730c425";
    --secret
    octo_conf.secret = "ef4d0fc9bd924f389217ad409f584af5";
    --server
    octo_conf.server = "http://10.165.126.103:8000";
    --expire 毫秒
    octo_conf.expire = 5000;

elseif _PROFILE == "production" then
    --production 环境

end


--返回配置信息
return octo_conf;

