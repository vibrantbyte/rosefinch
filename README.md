# light-api

开发中遇到app-api项目对于后端接口只是做透传，没有任何逻辑。app-api项目基于java技术栈进行开发，java是强类型语言，每次透传需要将feign中调用的对象转化成java对象，然后再将java对象转化成json对象传输给使用者。
这样做的目的有两点：
* token权限认证；
* 用户角色权限码过滤；

这样的代价就是我们很忙，每天在排查问题，做意义不是很大的透传工作，不管是哪一方出现问题，都需要多方出人出力。希望通过透传做权限实现责任边界清晰的方案，提高效率，划清责任；

## 解决方案
使用轻量级，高性能，高扩展、可监控的nginx作为透传方案，基于resty进行token解析，权限认证，黑白名单过滤；

## 目标
需求 -> 透传 -> 配置

之前工作模式下：1-2天；

新工作模式下：1-2小时；

## 方案

![light-api](http://vipkshttp0.wiz.cn/ks/share/resources/2148fa7e-1fb7-4327-a99f-927aa917025b/b53914ce-5c23-4550-8b2f-b6133a77f91e/index_files/56559132.png "light api")


## 快速启动
```` jshelllanguage
# 启动
# sudo ./src/bin/light-api.sh testing --start

# 停止
# sudo ./src/bin/light-api.sh testing --stop

# 重新加载
# sudo ./src/bin/light-api.sh testing --reload

````

 * /nginx/status nginx状态 ->
 http://localhost:8080/nginx/status
 * /test/http/bench 压测接口 ->
  http://localhost:8080/test/http/bench
 * /test/jwt 生成jwt
  http://localhost:8080/test/jwt
 * /v1/auth 代理auth系统
  http://localhost:8080/v1/auth
