
pipeline {
    agent any

    parameters {
        choice(
            name: 'BRANCH',
            choices: ['main', 'develop'],
            description: 'Select branch to build'
        )
    }

    environment {
        AWS_REGION = "ap-south-1"
        ECR_REPO   = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp"
        IMAGE_TAG  = "${1.0.0}"
        SONAR_ENV  = "sonarqubeServer"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: params.BRANCH,
                    url: 'https://github.com/your-org/my-java-app-ci.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONAR_ENV}") {
                    sh """
                    mvn clean verify sonar:sonar \
                    -Dsonar.projectKey=myapp \
                    -Dsonar.login=$SONAR_AUTH_TOKEN
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Docker Build (Maven inside Dockerfile)') {
            steps {
                sh """
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO

                docker build -t myapp:$IMAGE_TAG .
                docker tag myapp:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
                """
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh "docker push $ECR_REPO:$IMAGE_TAG"
            }
        }

        stage('Update GitOps Repo (Trigger Argo CD)') {
            steps {
                sh """
                rm -rf myapp-k8s
                git clone https://github.com/your-org/myapp-k8s.git
                cd myapp-k8s

                sed -i 's|image: .*|image: $ECR_REPO:$IMAGE_TAG|' deployment.yaml

                git config user.name "jenkins"
                git config user.email "jenkins@company.com"

                git add deployment.yaml
                git commit -m "Deploy image $IMAGE_TAG"
                git push origin main
                """
            }
        }
    }
}
