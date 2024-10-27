pipeline {
    agent any 

    environment {
        GIT_REPO_URL = 'https://github.com/Success-C-Opara/organicproject.git'
        BRANCH_NAME = 'main'
        DOCKER_IMAGE_NAME = 'organic-django-app'
        AWS_INSTANCE_IP = '3.80.209.86'
        SSH_KEY_PATH = '/var/lib/jenkins/success-aws-key.pem'
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
                    // Build the Docker image from the Dockerfile in the current directory
                    dir('.') {  // Using the root directory of the project
                        docker.build(DOCKER_IMAGE_NAME)
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    sh """
                    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} " \
                    # Pull the latest Docker image \
                    docker pull ${DOCKER_IMAGE_NAME} || true; \
                    
                    # Stop any running containers using the same image \
                    CONTAINER_ID=\$(docker ps -q --filter 'ancestor=${DOCKER_IMAGE_NAME}'); \
                    if [ -n '\$CONTAINER_ID' ]; then \
                        docker stop \$CONTAINER_ID; \
                        docker rm \$CONTAINER_ID; \
                    fi; \
                    
                    # Run the new container \
                    docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}"
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
