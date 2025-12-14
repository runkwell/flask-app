def DOCKER_HUB_USER = 'YOUR_DOCKERHUB_USERNAME' // Thay thế
def IMAGE_NAME = 'flask-app'
def EC2_HOST = '56.228.13.192' // Thay thế
def EC2_USER = 'ec2-user' // Hoặc 'ec2-user', tùy thuộc OS của EC2 Target
def DOCKER_HUB_CRED_ID = 'DockerHub-Cred' // ID Credentials trong Jenkins
def EC2_SSH_CRED_ID = 'EC2-SSH-Key' // ID Credentials trong Jenkins
def REPOSITORY_PATH = "${DOCKER_HUB_USER}/${IMAGE_NAME}"

pipeline {
    agent {
        label 'docker aws' // Đảm bảo Agent có 2 Label này
    }

    stages {
        stage('Check Agent Tools') {
            steps {
                echo "Running on agent: ${env.NODE_NAME}"
                sh 'docker info'
                sh 'aws --version'
                // Thêm kiểm tra SSH nếu cần
            }
        }

        stage('Checkout Code') {
            steps {
                // Kéo code từ repo Git (ví dụ: GitHub, GitLab)
                checkout scm 
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building image ${REPOSITORY_PATH}:${env.BUILD_NUMBER}"
                    // Sử dụng BUILD_NUMBER làm tag
                    sh "docker build -t ${REPOSITORY_PATH}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Sử dụng credentials Docker Hub đã tạo
                withCredentials([usernamePassword(credentialsId: DOCKER_HUB_CRED_ID, 
                                                passwordVariable: 'DOCKER_PASSWORD', 
                                                usernameVariable: 'DOCKER_USER')]) {
                    script {
                        // Đăng nhập Docker Hub
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USER} --password-stdin"
                        
                        // Đẩy image lên Docker Hub
                        sh "docker push ${REPOSITORY_PATH}:${env.BUILD_NUMBER}"
                        
                        // Đẩy tag latest (tùy chọn)
                        sh "docker tag ${REPOSITORY_PATH}:${env.BUILD_NUMBER} ${REPOSITORY_PATH}:latest"
                        sh "docker push ${REPOSITORY_PATH}:latest"
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                // Sử dụng SSH Agent Plugin hoặc SSH Steps
                // Đây là cách sử dụng plugin 'ssh-agent' (cần cài đặt)
                sshagent(credentials: [EC2_SSH_CRED_ID]) {
                    sh """

                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} << EOF
                            
                            echo "Pulling new image from Docker Hub..."

                            docker pull ${REPOSITORY_PATH}:latest
                            
                            echo "Stopping old container..."

                            docker stop flask-app-container || true
                            
                            echo "Removing old container..."

                            docker rm flask-app-container || true
                            
                            echo "Starting new container..."

                            docker run -d \\
                                --name flask-app-container \\
                                -p 80:80 \\
                                ${REPOSITORY_PATH}:latest
                            
                            echo "Deployment finished."
                        EOF
                    """
                }
            }
        }
    }
}
