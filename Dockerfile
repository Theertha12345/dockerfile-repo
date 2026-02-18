FROM: termline -jdk 17
WORKDIR: /ubuntu/home
COPY: App.java /ubuntu/home
RUN: maven clean install & maven clean package 
