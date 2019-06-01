---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xiaoyueya.
--- DateTime: 2019/5/31 下午5:01
---

local cityTimeService = require("src.service.city_time_service")
---1、获取post请求中的参数city
ngx.req.read_body()
local args = ngx.req.get_post_args()
--- 获取city
local city = nil
for key, val in pairs(args) do
    if key == "city" then
        city = val
    end
end

--- 2、拼接url
local distributionUrl = cityTimeService.getUrl();
local request_uri = ngx.var.request_uri;
local url = ""
local urlLen = (distributionUrl and #distributionUrl) or 0;
if urlLen > 0 then
    url = distributionUrl[1].url..request_uri;
else
    url = "http://localhost:8087"..request_uri;
end
--- 如果没有这个参数不做处理
local current = 0;
if city then
    --- 3、去数据库中查找城市
    local time = cityTimeService.getTimeFromCIty(city)
    local len = (time and #time) or 0
    if len > 0 then
        --- 返回结果
        current = time[1].current_time;
    end
end

ngx.req.read_body();
--- current = current,
ngx.req.set_header("CurrentTime",current);
local res = ngx.location.capture('/limit_internet_proxy',
        {
            method = ngx.HTTP_POST,
            copy_all_vars = true
        }
);

--- 响应消息体
ngx.print(res.body)



