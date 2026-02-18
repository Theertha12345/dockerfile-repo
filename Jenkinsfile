 pipeline
   agent any {

    tools {
     maven : maven-3
     } 

   environmet {
       AWS_REGEN : ap-south-02
       INSTANCE ID : i-00de154c02a6adb05
       PRIVATE_IP : 172.31.5.104
       PATH : /home/ubuntu




    stages{
      stage('checkout'){
        steps { 
        git origin :' main' 
        git-URL : 'https://github.com/Theertha12345/dockerfile-repo.git'
       }
    }

      stage('build') {
        steps {
        sh '' 
           'docker build -t myapp:tag 0.1'
         '' 
       }
    }

     stage ('depoly on ec2 server'){
       steps { 
         sh " " "
             ssh($'PRIVATE_IP')

  
