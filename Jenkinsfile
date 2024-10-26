pipeline {
    agent any 

    environment {
        // Define environment variables
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
                    # Stop any running containers using the same image
                    docker stop \$(docker ps -q --filter "ancestor=${DOCKER_IMAGE_NAME}") || true
                    # Remove old containers
                    docker rm \$(docker ps -aq --filter "ancestor=${DOCKER_IMAGE_NAME}") || true
                    # Pull the latest Docker image
                    docker pull ${DOCKER_IMAGE_NAME}
                    # Run the new container
                    docker run -d -p 80:8000 ${DOCKER_IMAGE_NAME}
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
