# backend/app.py
from flask import Flask, jsonify
import socket
import psutil

app = Flask(__name__)

@app.route('/api/system_info', methods=['GET'])
def get_system_info():
    # 获取主机名
    hostname = socket.gethostname()

    # 获取CPU使用率
    cpu_percent = psutil.cpu_percent(interval=1)

    # 获取内存使用情况
    memory_info = psutil.virtual_memory()
    memory_percent = memory_info.percent

    # 获取容器信息（如果在容器中运行）
    try:
        with open('/proc/1/cgroup', 'r') as f:
            cgroup = f.read()
    except:
        cgroup = 'N/A'

    system_info = {
        'hostname': hostname,
        'cpu_percent': cpu_percent,
        'memory_percent': memory_percent,
        'cgroup': cgroup
    }

    return jsonify(system_info)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)