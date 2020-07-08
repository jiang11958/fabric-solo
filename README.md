> 本教程是《Fabric实战教程之一步步走向生产》系列教程的第二篇，主要介绍单机环境下基于docker实现fabric最简网络。

### 教程目录结构如下：

1. [简介](https://juejin.im/post/5effac395188252e7165ab64)
2. [基于docker部署最简fabric网络](https://juejin.im/post/5effb2bfe51d4534791d4660)
3. [基于docker部署多机fabric网络](https://juejin.im/post/5f05030ef265da22e610e192)
4. [一键部署k8s集群]
5. [基于helm一键部署fabric网络]
6. [fabric-ca快速生成MSP证书]
7. [connection-profile配置文件自动生成]
8. [blockchain-explorer部署与配置]
9. [国内网络下的网络搭建调整细节]
10. [踩坑总结]

<br>

> 本文教程在阿里云海外服务器上面实操，由于国内网络问题，docker和镜像都比较难下载，后面第九篇介绍国内网络下的脚本调整细节。

> 主机系统版本如下
```
[root@test ~]# cat /etc/redhat-release 
CentOS Linux release 7.6.1810 (Core) 
[root@test ~]# uname -a
Linux test 3.10.0-957.21.3.el7.x86_64 #1 SMP Tue Jun 18 16:35:19 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
```
<br>

> fabric网络拓扑如下：


![](https://user-gold-cdn.xitu.io/2020/7/4/17316ff29ffff993?w=1081&h=543&f=png&s=24018)

##### 一键启动
```
cd ~
git clone https://github.com/jiang11958/fabric-solo
cd ~/fabric-solo
sh run.sh start
```
##### 一键清除
```
cd ~/fabric-solo
sh run.sh stop
```
