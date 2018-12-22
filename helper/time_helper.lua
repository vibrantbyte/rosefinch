--[[
    作者：suchao@renrenche.com
    描述：time tool
    时间：2018-12-22 10:19:00
]]
local _M = {_VERSION="0.1.0"};
local ffi = require("ffi")
ffi.cdef[[
    struct timeval {
        long int tv_sec;
        long int tv_usec;
    };
    int gettimeofday(struct timeval *tv, void *tz);
]];
local tm = ffi.new("struct timeval");

-- 返回微秒级时间戳
function _M.current_time_millis()
    ffi.C.gettimeofday(tm,nil);
    local sec =  tonumber(tm.tv_sec);
    local usec =  tonumber(tm.tv_usec);
    return sec + usec * 10^-6;
end

--获取当天结束的时间
function _M.get_today_over()
    local cDateCurrectTime = os.date("*t");
    local cDateTodayTime = os.time({year=cDateCurrectTime.year, month=cDateCurrectTime.month, day=cDateCurrectTime.day, hour=23,min=59,sec=59});
    return cDateTodayTime
end

return _M;