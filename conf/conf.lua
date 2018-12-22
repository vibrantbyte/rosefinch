--[[
    作者：suchao@renrenche.com
    描述：base configure
    时间：2018-12-22 10:19:00
]]

conf = {_VERSION="0.1.0"}

conf.profile = "testing";


--拉取服务器失败返回
---@field fault_response table
conf.fault_response = {
    version = 0,
    status = -5,
    err_msg = "gateway fault.",
    error_msg = "gateway fault.",
    data = nil,
}

return conf;