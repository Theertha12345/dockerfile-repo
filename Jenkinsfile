pipeline {
    agent any

    parameters {
        choice(
            name: 'BRANCH',
            choices: ['main', 'develop', 'release'],
            description: 'Select branch to build'
        )
    }

    environment {
        PROJECT_KEY = "my-java-app"
        AWS_REGION  = "ap-south-2"
        ECR_REPO    = "692614315837.dkr.ecr.ap-south-2.amazonaws.com/myrepo"
        IMAGE_TAG   = "${BUILD_NUMBER}"
        MANIFEST_REPO = "https://github.com/your-username/my-k8s-manifests.git"
    }

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    stages {

        stage('Checkout Application Code') {
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

        stage('Docker Build & Push to ECR') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-creds']
                ]) {
                    sh """
                        aws ecr get-login-password --region $AWS_REGION \
                        | docker login --username AWS --password-stdin $ECR_REPO

                        docker build -t myapp:$IMAGE_TAG .
                        docker tag myapp:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
                        docker push $ECR_REPO:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Update Kubernetes Manifest Repo (GitOps)') {
            steps {
                dir('k8s-manifests') {

                    git branch: 'main',
                        credentialsId: 'github-creds',
                        url: "https://github.com/Theertha12345/argo-cd.git"

                    withCredentials([usernamePassword(
                        credentialsId: 'github-creds',
                        usernameVariable: 'GIT_USERNAME',
                        passwordVariable: 'GIT_PASSWORD'
                    )]) {

                        sh """
                            sed -i "s|myrepo:.*|myrepo:${IMAGE_TAG}|g" deployment.yaml

                            git config user.name "jenkins"
                            git config user.email "jenkins@company.com"

                            git add .
                            git commit -m "Updated image tag to ${IMAGE_TAG}" || echo "No changes"

                            git remote set-url origin https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/your-username/my-k8s-manifests.git
                            git push origin main
                        """
                    }
                }
            }
        }
    }
}
