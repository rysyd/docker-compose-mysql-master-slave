# 使用 docker-compose 部署本地 mysql 主从环境

本项目由 tarunlalwani 的项目修改，如有需要可以访问原repository：[链接](<https://github.com/tarunlalwani/docker-compose-mysql-master-slave>)

# Usage

如需要修改 mysql 默认账号密码，请修改 docker-compose.yml 文件内容

假定你已经安装了 docker-compose

1、clone 这个地址

```shell
$ git clone https://github.com/hlwojiv/docker-compose-mysql-master-slave.git
```

2、进入目录，部署 mysql 主从

```shell
$ cd docker-compose-mysql-master-slave
$ docker-compose up -d
```

3、查看配置是否成功

```shell
$ docker logs -f mysql-config
```

