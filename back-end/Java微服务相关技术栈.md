# Java微服务相关技术栈

## 微服务构建顺序

nacos注册所有服务并将服务配置挂载到nacos上

使用OpenFeign获取nacos服务并实现服务间调用

使用okhttp优化OpenFeign

使用LoadBalancer优化OpenFeign负载均衡





## 注册中心/配置中心——NACOS

**作用：**将所有服务组件注册到nacos中，统一使用nacos进行管理，完成配置中心化管理，使用名字代理端口调用不同微服务，进而实现不同服务间的解耦



## 服务间调用——OpenFeign/Dubbo

**作用：**不同服务间接口调用的解决方案，使用FeignClient进行接口间通讯

## 负载均衡——LoadBalencer

## 网关——Gateway

**作用：**网关使用一个port，然后前端将所有的请求发到网关应用，网关通过向naocs获取服务，使用服务名称完成收到的消息的转发

## 分布式事务——Seata

## 微服务保护——Sentinel

## 消息队列（解耦&削峰）——RocketMQ

## 分库——ShardingSphere（ShardingJDBC）

## 分表——MP分表插件

## 分布式限流&分布式锁——Redis&Redission

## 任务调度——xxl-Job

