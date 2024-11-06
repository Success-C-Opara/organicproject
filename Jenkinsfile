pipeline {
    agent any 

    environment {
        GIT_REPO_URL = 'https://github.com/Success-C-Opara/organicproject.git'
        BRANCH_NAME = 'main'
        DOCKER_IMAGE_NAME = 'organic-django-app'
        AWS_INSTANCE_IP = '54.89.211.243'
        SSH_KEY_PATH = '/var/lib/jenkins/success-aws-key.pem'
        DOCKER_IMAGE_TAR = 'organic-django-app.tar'
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

        stage('Save Docker Image') {
            steps {
                script {
                    // Save the Docker image to a tar file so it can be transferred to the EC2 instance
                    sh "docker save -o ${DOCKER_IMAGE_TAR} ${DOCKER_IMAGE_NAME}"
                }
            }
        }

        stage('Transfer Docker Image to AWS') {
            steps {
                script {
                    // Transfer the Docker image tar file to the AWS EC2 instance
                    sh """
                    scp -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ${DOCKER_IMAGE_TAR} ubuntu@${AWS_INSTANCE_IP}:/home/ubuntu/
                    """
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    sh """
                    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} " \
                    # Install Docker if not installed \
                    if ! command -v docker &> /dev/null; then \
                        sudo apt update && sudo apt install -y docker.io; \
                    fi; \
                    
                    # Load the Docker image from the tar file \
                    sudo docker load -i /home/ubuntu/${DOCKER_IMAGE_TAR}; \
                    
                    # Stop any running containers using the same image \
                    CONTAINER_ID=\$(sudo docker ps -q --filter 'ancestor=${DOCKER_IMAGE_NAME}'); \
                    if [ -n '\$CONTAINER_ID' ]; then \
                        sudo docker stop \$CONTAINER_ID; \
                        sudo docker rm \$CONTAINER_ID; \
                    fi; \
                    
                    # Run the new container \
                    sudo docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}"
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
