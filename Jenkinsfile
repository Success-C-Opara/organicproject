pipeline {
    agent any 

    environment {
        // Define environment variables
        GIT_REPO_URL = 'https://github.com/yourusername/your-repo.git'
        BRANCH_NAME = 'main'  // Change to your target branch
        DOCKER_IMAGE_NAME = 'your-django-app'
        AWS_INSTANCE_IP = 'your-ec2-instance-ip'
        SSH_KEY_PATH = credentials('your-ssh-key-id') // Jenkins credentials ID for SSH key
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the specified branch
                    git branch: BRANCH_NAME, url: GIT_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    // Deploy the Docker container to AWS instance
                    sshagent (credentials: ['your-ssh-key-id']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ec2-user@${AWS_INSTANCE_IP} << EOF
                        docker pull ${DOCKER_IMAGE_NAME}
                        docker stop \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                        docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}
                        EOF
                        """
                    }
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
