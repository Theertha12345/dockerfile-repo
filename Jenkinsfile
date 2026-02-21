pipeline {
    agent any

    parameters {
        choice(
            name: 'BRANCH',
            choices: ['main', 'develop','release'],
            description: 'Select branch to build'
        )
    }

    environment {
        PROJECT_KEY = "my-java-app"
        AWS_REGION  = "ap-south-2"
        ECR_REPO    = "692614315837.dkr.ecr.ap-south-2.amazonaws.com/myrepo"
        IMAGE_TAG   = "1.0.0"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: params.BRANCH,
                    url: 'https://github.com/Theertha12345/dockerfile-repo.git'
            }
        }

        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    withCredentials([
                        string(credentialsId: 'jenkins-token1', variable: 'SONAR_TOKEN')
                    ]) {
                        sh """
                        mvn clean verify sonar:sonar \
                          -Dsonar.projectKey=${PROJECT_KEY} \
                          -Dsonar.projectName=${PROJECT_KEY} \
                          -Dsonar.token=$SONAR_TOKEN
                        """
                    }
                }
            }
        }

        stage('Docker Build & Push to ECR (Maven inside Dockerfile)') {
    steps {
        withCredentials([
            [$class: 'AmazonWebServicesCredentialsBinding',
             credentialsId: 'aws-creds']
        ]) {
            sh """
                echo "Logging into AWS ECR"
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO

                echo " Building Docker image"
                docker build -t myapp:$IMAGE_TAG .

                echo "Tagging image"
                docker tag myapp:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG

                echo " Pushing image to ECR"
                docker push $ECR_REPO:$IMAGE_TAG
            """
        }
    }
}
