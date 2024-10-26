pipeline {
    agent any 

    environment {
        GIT_REPO_URL = 'https://github.com/Success-C-Opara/organicproject.git'
        BRANCH_NAME = 'main'
        DOCKER_IMAGE_NAME = 'organic-django-app'
        AWS_INSTANCE_IP = '3.87.212.152'
        SSH_KEY_PATH = '/var/lib/jenkins/success-aws-key.pem' // Adjust this path as needed
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: BRANCH_NAME, url: GIT_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Test SSH Connection') {
            steps {
                script {
                    // Test SSH connection
                    sh "ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} 'echo Connected'"
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    sh """
                    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} << EOF
                    docker stop \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}") || true
                    docker rm \$(docker ps -aq --filter "ancestor=${DOCKER_IMAGE_NAME}") || true
                    docker run -d --restart unless-stopped -p 80:8000 ${DOCKER_IMAGE_NAME}
                    EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}
