pipeline {
    agent any
    
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh '''
                    sudo su
                    docker stop Onix-Website || true
                    docker rm Onix-Website || true
                    docker build -t mywebsite .
                    '''
                }
            }
        }