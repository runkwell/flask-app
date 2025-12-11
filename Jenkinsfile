// Jenkinsfile
pipeline {
    agent any
    
    // Khai báo các biến môi trường
    environment {
        // Thay bằng URI ECR của bạn
        ECR_REGISTRY = '325538745984.dkr.ecr.eu-north-1.amazonaws.com/my-flask-app' 
        IMAGE_NAME = 'my-flask-app'
        IMAGE_TAG = 'latest'
        # Thay bằng region của bạn
        AWS_REGION = 'eu-north-1' 
        ECS_CLUSTER = 'Flask-Cluster'
        ECS_SERVICE = 'flask-service'
    }

    stages {
        stage('Checkout Code') {
            steps {
                # Kéo code từ repo Git (ví dụ: GitHub, GitLab)
                checkout scm 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    # Đăng nhập vào ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    
                    # Xây dựng Docker Image
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    
                    # Tag image để chuẩn bị push lên ECR
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    # Đẩy image lên ECR
                    sh "docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    # Cập nhật ECS Service. ECS sẽ tự động kéo image mới nhất từ ECR và triển khai.
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }
    }
}