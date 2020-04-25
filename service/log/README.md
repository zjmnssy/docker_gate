# docker-deploy
服务进docker部署模板，以etcd为示例

# 目录
```
docker-deploy    //工程根目录
├── deploy.sh    //docker容器自动部署脚本
├── docker-image-build    //docker镜像创建目录
│   ├── Dockerfile    //docker镜像创建文件
│   ├── keepContainerAlive.sh    //docker容器保活脚本
│   └── packages    ////docker镜像创建文件中需要在创建镜像是导入的包目录
│       └── etcd-v3.3.9-linux-amd64.tar.gz    //导入的etcd服务包
├── README.md    //说明文件
└── service    //挂载到容器中的服务目录
    ├── bin    //可执行程序目录
    │   ├── etcd    //
    │   ├── etcd.yml    //
    │   ├── monitor.sh    //
    │   ├── reStart.sh    //
    │   ├── start.sh    //
    │   └── stop.sh    //
    └── tls    //etcd使用的证书目录
        ├── ca.pem    //根证书
        ├── etcd-key.pem    //私钥
        └── etcd.pem    //证书
```
  
# 说明
1、已经在Ubuntu18.04验证，项目可运行  
2、直接运行deploy.sh脚本文件，即可完成etcd镜像创建和容器的启动  

