# nacos运行命令
# https://github.com/alibaba/spring-cloud-alibaba/blob/2023.x/spring-cloud-alibaba-examples/nacos-example/readme-zh.md
# NACOS_AUTH_ENABLE=true，若为false则nacos的网页控制面板不需要密码即可登录，微服务连接nacos也不需要用户名密码
# 若设置了NACOS_AUTH_ENABLE=true，则以下变量必须设置
# NACOS_AUTH_IDENTITY_KEY、NACOS_AUTH_IDENTITY_VALUE，用途未知（不是nacos的登录用户名和密码），变量值可任意自定义，不设置会导致nacos控制面板在打开时报告403
# NACOS_AUTH_TOKEN，用途未知，默认值如命令所示，格式为SecretKey后接base64字符串
docker rm -fv nacos-server
docker run --name nacos-server \
  --restart=always \
  -e MODE=standalone \
  -e NACOS_AUTH_ENABLE=true \
  -e NACOS_AUTH_IDENTITY_KEY=nacos \
  -e NACOS_AUTH_IDENTITY_VALUE=nacos \
  -e NACOS_AUTH_TOKEN=SecretKey012345678901234567890123456789012345678901234567890123456789 \
  -p 8848:8848 -p 9848:9848 -p 9849:9849 \
  -d nacos/nacos-server:v2.3.2

docker rm -f mysql
docker run --name mysql \
  --restart=always \
  -v /opt/mysql/conf.d:/etc/mysql/conf.d \
  -v /opt/mysql/data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  -d mysql:8.0.33

# 每60秒检测一次，若从上一次执行快照开始，到本次执行检测的这段时间内，至少有1次写入操作，则进行一次快照保存
docker rm -f redis
docker run --name redis \
  --restart=always \
  -v /opt/redis/data:/data \
  -e REDIS_PASSWORD=123456 \
  -p 6379:6379 \
  -d redis:7.2.5-alpine \
  /bin/sh -c '
  redis-server --save 60 1 \
    --loglevel warning \
    --requirepass ${REDIS_PASSWORD}
  '