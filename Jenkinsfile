 pipeline
   agent any {

    tools {
     maven : maven-3
     } 

   environmet {
       AWS_REGEN : 'ap-south-02'
       INSTANCE ID : 'i-00de154c02a6adb05'
       PRIVATE_IP : '172.31.5.104'
       EC2_PASS : 'ssh-ec2'
       PATH : /home/ubuntu
      


    stages{
      stage('checkout'){
        steps { 
        git origin :'main' 
        git-URL : 'https://github.com/Theertha12345/dockerfile-repo.git'
       }
    }

      stage('build') {
        steps {
        sh '' 
           'docker build -t myapp:tag 0.1 .'
         '' 
       }
    }

     stage('Deploy to EC2') {
            steps {
                sshagent([SSH_CREDENTIALS]) {

                    sh """
                    scp -o StrictHostKeyChecking=no target/*.jar ${EC2_USER}@${EC2_IP}:/home/${EC2_USER}/${APP_NAME}
                    """
          }
        }
     }
  }  
