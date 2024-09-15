#!/bin/bash

# 用法说明
function usage() {
    echo "用法: $0 -n <namespace> -a <app_name> -i <image> -t <tag>"
    exit 1
}

# 解析输入参数
while getopts "n:a:i:t:" opt; do
  case ${opt} in
    n )
      NAMESPACE=$OPTARG
      ;;
    a )
      APP_NAME=$OPTARG
      ;;
    i )
      IMAGE=$OPTARG
      ;;
    t )
      TAG=$OPTARG
      ;;
    \\? )
      usage
      ;;
  esac
done

# 验证必要的参数是否存在
if [ -z "$NAMESPACE" ] || [ -z "$APP_NAME" ] || [ -z "$IMAGE" ] || [ -z "$TAG" ]; then
    usage
fi

# 生成 Kubernetes manifest 文件
cat <<EOF > deployment/local_testing/${NAMESPACE}-docker-compose.yml
version: "3.9"
services: 
  nginx:
    image: $(IMAGE):$(TAG)
    container_name: nginx-$(TAG)
    ports:
      - "9080:80"

EOF
