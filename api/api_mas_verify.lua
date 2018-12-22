--[[
    作者：suchao@renrenche.com
    描述：mas verify service
    时间：2018-12-22 10:19:00
]]
local mas_service = require("service.mas_service");
local authority_service = require("service.authority_service")
local cjson = require("cjson")



ngx.header.content_type = "text/plain";
--get param from uri
local request_uri = ngx.var.request_uri;
ngx.print(cjson.encode(request_uri));

ngx.print("\r\n");

local scheme = ngx.var.scheme;
ngx.print(cjson.encode(scheme));

ngx.print("\r\n");

local server_addr = ngx.var.server_addr;
ngx.print(cjson.encode(server_addr));

ngx.print("\r\n");

local uri = ngx.var.uri;
ngx.print(cjson.encode(uri));

ngx.print("\r\n");

local server_name  = ngx.var.server_name;
ngx.print(cjson.encode(server_name))

ngx.print("\r\n");

local server_port  = ngx.var.server_port;
ngx.print(cjson.encode(server_port))

ngx.print("\r\n");

local request_args_tab = ngx.req.get_uri_args();
ngx.print(cjson.encode(request_args_tab))


local body = mas_service.verify("LG4Mb9qDKq19-sL6YJ6Re35L0g-pGCGO2inBCo4tk-k");
--ngx.print("hello")
if body.status == 0 then
    local data = body.data;
    --ngx.print(data.userId);
    user_info = authority_service.get_user_authority(data.userId);
    --ngx.print(cjson.encode(user_info));
end
