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
cat <<EOF > deployment/kubernetes/${NAMESPACE}/${APP_NAME}.yaml
# Create namespace: $NAMESPACE
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE

---
# Create deployment of backend service
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ${APP_NAME}-deploy
  name: ${APP_NAME}-deploy
  namespace: $NAMESPACE
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${APP_NAME}-deploy
  template:
    metadata:
      labels:
        app: ${APP_NAME}-deploy
    spec:
      containers:
      - image: ${IMAGE}:${TAG}
        name: ${APP_NAME}
        resources: 
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi

---
# Create service to expose backend deployment
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-service
  namespace: $NAMESPACE
  labels:
    app: ${APP_NAME}-service
spec:
  ports:
  - port: 5000
    targetPort: 5000
    protocol: TCP
  selector:
    app: ${APP_NAME}-deploy
EOF
