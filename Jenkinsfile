pipeline {
    agent any

    environment {
        // AWS Config
        AWS_ACCOUNT_ID = '590183744625'
        AWS_REGION = 'ap-south-1'
        IMAGE_NAME = 'nodeapp'
        REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"

        // SonarQube environment
        SONARQUBE_ENV = 'sonar'
    }

    tools {
        nodejs 'nodejs' // optional: if NodeJS is managed by Jenkins tools
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'github', 
                    url: 'https://github.com/Mayankjha796/calculator.git', 
                    branch: 'master'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    script {
                        sh """
                        sonar-scanner \
                        -Dsonar.projectKey=calculator \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${env.SONAR_HOST_URL} \
                        -Dsonar.login=${env.SONAR_AUTH_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "/usr/bin/docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPO}
                    """
                }
            }
        }

        stage('Tag & Push Docker Image') {
            steps {
                script {
                    def imageTag = "${REPO}:${env.BUILD_NUMBER}"
                    sh """
                    docker tag ${IMAGE_NAME}:latest ${imageTag}
                    docker push ${imageTag}
                    """
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and push successful!'
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}
