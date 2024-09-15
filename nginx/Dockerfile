# nginx/Dockerfile

# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:1.27.1-alpine3.20-perl

# 删除默认的 Nginx 配置文件
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]