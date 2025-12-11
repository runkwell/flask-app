# Sử dụng image nền tảng python nhẹ
FROM python:3.9-slim

# Thiết lập thư mục làm việc bên trong container
WORKDIR /app

# Sao chép dependencies và cài đặt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép code ứng dụng
COPY . .

# Mở cổng 80 (cổng mà Flask đang chạy)
EXPOSE 80

# Lệnh chạy ứng dụng khi container khởi động
CMD ["python", "app.py"]