#!/usr/bin/env bash

echo "/*************************************************************************/"
echo "/*                                                                       */"
echo "/*                                Deploy                                 */"
echo "/*                                                                       */"
echo "/*************************************************************************/"

# NOTE: 获取当前工作路径
currentPath=$(cd `dirname $0`; pwd)
echo "[INFO] current work path : $currentPath"



# ************************** 系统配置 start (根据实际情况修改) ***********************
# NOTE: 物理主机实际网卡名称
hostNetworkCardName="eth0"
# *************************************** end ************************************



# **************************** 容器配置 start  (根据实际情况修改) ********************
# NOTE: Dockerfile生成的镜像的名称
imageName="zaa"

# NOTE: Dockerfile生成的镜像的版本
imageVersion="d20200425"

# NOTE: Dockerfile生成的镜像的文件名
imageFile="zaa_image.tar"

# NOTE: 启动容器的名称
containerName="zaa"
# *************************************** end ***********************************



# ******************************* 不需要修改的配置 start ***************************
imageNameVersion="$imageName:$imageVersion"

# NOTE: 镜像制作路径
imageBuildPath="$currentPath/docker-image-build"

# NOTE: 镜像制作脚本文件
imageDockerfile="Dockerfile"

# NOTE: 容器内可执行文件目录
hostBinPath="$currentPath/service/bin"
containerBinPath="/root/service/bin"

# NOTE: 容器内配置文件目录
hostConfigPath="$currentPath/service/config"
containerConfigPath="/root/service/config"

# NOTE: 容器内数据存储目录
hostDataPath="$currentPath/service/data"
containerDataPath="/root/service/data"

# NOTE: 容器内日志文件目录
hostLogPath="$currentPath/service/log"
containerLogPath="/root/service/log"

# NOTE: 获取物理主机IP地址，注意hostNetworkCardName需要正确填写网卡名称
localAddress=""
# *************************************** end ***********************************



# ************************** 导入容器内的配置 start  (根据实际情况修改) **************
# NOTE: 服务程序名称
programName="zaa_server"

# NOTE: 服务程序的配置文件名称
programStartFlag="-c=$containerConfigPath/config.json"

# *************************************** end ************************************





# NOTE: 获取物理主机IP地址
getHostIp() {
    localAddress=$(ifconfig $hostNetworkCardName|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}')
    echo "[INFO] - getHostIp():set localAddress=$localAddress"
}
getHostIp

# NOTE: 调用Dockerfile，创建镜像
dockerImageBuild() {
    echo "[INFO] - dockerImageBuild()：begin build $imageNameVersion."
    cd $imageBuildPath
    sudo docker build --file $imageBuildPath/$imageDockerfile -t $imageNameVersion .
    cd $currentPath
}

# NOTE: 检查docker是否安装
checkDockerInstall() {
    echo "[INFO] - checkDockerInstall()：check is docker has installed."
    checkRet=$(sudo docker version | grep Version | awk -F" " '{print $2}' | awk 'NR==1{print}')
    echo "[INFO] ----docker version : '$checkRet'"
}

# NOTE: 检查docker镜像，不存在则创建
checkDockerImage() {
    echo "[INFO] - checkDockerImage()：check '$imageName' image"
    imageCheck=$(sudo docker images | grep $imageName | awk '{print $1}')
    if [ "$imageCheck" ] ; then
        echo "[INFO] ----'$imageName' is exist, nothing to do."
    else
        echo "[INFO] ----'$imageName' not exist, please input get image method:"
        while :
        do
            echo "[INFO] --------1 - load from image file"
            echo "[INFO] --------2 - create from dockerfile"
            read methodNum
            if [[ $methodNum == 1 ]]; then
                chmod 666 $imageFile
                sudo docker load < $imageFile
                break
            elif [[ $methodNum == 2 ]]; then
                dockerImageBuild
                break
            else
                echo "[ERRO] --------error method number, try again!"
                exit
            fi
        done
    fi
}
checkDockerImage

# NOTE: 检查docker容器，不存在则创建并启动
checkDockerContainer() {
    echo "[INFO] - checkDockerContainer()：check '$containerName' container"
    containerCheck=$(sudo docker ps -a|grep $containerName)
    if [ "$containerCheck" ] ; then
        echo "[INFO] ----'$containerName' is exist, nothing need to start."
    else
        echo "[INFO] ----begin run $containerName container."
        
        sudo docker run -d -p 6666:6666 -e HOST_IP=$localAddress -e PROGRAM_NAME=$programName -e START_FLAG=$programStartFlag -e BIN_PATH=$containerBinPath -e CONFIG_PATH=$containerConfigPath -e DATA_PATH=$containerDataPath -e LOG_PATH=$containerLogPath -v $hostBinPath:$containerBinPath -v $hostConfigPath:$containerConfigPath -v $hostDataPath:$containerDataPath -v $hostLogPath:$containerLogPath --restart always --name $containerName $imageNameVersion
    fi
}
checkDockerContainer

