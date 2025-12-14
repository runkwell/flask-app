from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '<h1>Hello World from a Container on ec2!</h1>'

if __name__ == '__main__':
    # Chạy trên cổng 80, hoặc cổng mà container được cấu hình để lắng nghe
    app.run(host='0.0.0.0', port=80)
