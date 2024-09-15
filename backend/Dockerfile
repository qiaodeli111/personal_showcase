# backend/Dockerfile

# 使用官方 Python 镜像作为基础镜像
FROM python:3.11.10-slim

# 设置环境变量，确保输出是实时的
ENV PYTHONUNBUFFERED=1

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app.py .

# 暴露端口
EXPOSE 5000

# 运行应用
CMD ["python", "app.py"]