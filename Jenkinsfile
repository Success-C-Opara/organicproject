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
                    git branch: BRANCH_NAME, url: GIT_REPO_URL
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image from the Dockerfile
                    docker.build(DOCKER_IMAGE_NAME)
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    // Deploy the Docker container to the AWS instance
                    sh """
                    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ubuntu@${AWS_INSTANCE_IP} << EOF
                    # Build the Docker image on the AWS instance
                    cd /path/to/your/app  # Change to the directory where your Dockerfile is located
                    sudo docker build -t ${DOCKER_IMAGE_NAME} .

                    # Stop any running containers using the same image
                    CONTAINER_ID=\$(sudo docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}")
                    if [ -n "\$CONTAINER_ID" ]; then
                        sudo docker stop \$CONTAINER_ID
                    fi
                    
                    # Run the new container
                    sudo docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}
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
