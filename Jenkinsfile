pipeline {
    agent any 

    environment {
        GIT_REPO_URL = 'https://github.com/Success-C-Opara/organicproject.git' // Your GitHub repo
        BRANCH_NAME = 'main'  // Target branch
        DOCKER_IMAGE_NAME = 'organic-django-app' // Name for your Docker image
        AWS_INSTANCE_IP = '3.80.209.86' // Public IP of your deployment instance
        SSH_KEY_PATH = '/var/lib/jenkins/success-aws-key.pem' // Path to your SSH key on the AWS instance
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
                    // Build the Docker image from the Dockerfile
                    try {
                        docker.build(DOCKER_IMAGE_NAME)
                    } catch (Exception e) {
                        error("Docker build failed: ${e.message}")
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    // Deploy the Docker container to the AWS instance
                    try {
                        sh """
                        ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} << EOF
                        # Pull the latest Docker image
                        sudo docker pull ${DOCKER_IMAGE_NAME} || true
                        # Stop any running containers using the same image
                        sudo docker stop \$(sudo docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}") || true
                        # Run the new container
                        sudo docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}
                        EOF
                        """
                    } catch (Exception e) {
                        error("Deployment to AWS failed: ${e.message}")
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
