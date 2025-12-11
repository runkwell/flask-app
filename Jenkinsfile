// Jenkinsfile
pipeline {
    agent any
    
    // Khai báo các biến môi trường
    environment {
        // Thay bằng URI ECR của bạn
        ECR_REGISTRY = '325538745984.dkr.ecr.eu-north-1.amazonaws.com/my-flask-app' 
        IMAGE_NAME = 'my-flask-app'
        IMAGE_TAG = 'latest'
        AWS_REGION = 'eu-north-1' 
        ECS_CLUSTER = 'Flask-cluster'
        ECS_SERVICE = 'flask-service'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm 
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}"
                    
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh "docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                script {
                    sh "aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_SERVICE} --force-new-deployment --region ${AWS_REGION}"
                }
            }
        }
    }
}