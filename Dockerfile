FROM: termline -jdk 17
WORKDIR: /ubuntu/home
COPY: App.java target
RUN: maven clean install & maven clean package 
