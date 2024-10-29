pipeline {
    agent any

    tools {
        // Tools
        maven 'maven'
        jdk 'jdk-17'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        git url: 'https://github.com/Anjana-Natha/EurekaServer.git', branch: 'main'
                    }
                }
            }
        }

        stage('Pre-Build') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        bat '''
                        docker stop registry-sr || true
                        docker rm registry-sr || true
                        docker rmi -f registry-service:latest || true
                        '''
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        bat 'mvn clean install'
                    }
                }
            }
        }

        stage('Create Docker Network') {
            steps {
                script {
                    // Create a Docker network, ignore errors if it already exists
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        bat 'docker network create my-network || echo "Network already exists"'
                    }
                }
            }
        }

        stage('Post-Build') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        bat '''
                        docker build -t registry-service:latest .
                        docker run -d --network my-network -p 8761:8761 --name registry-sr registry-service:latest
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed!'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline had errors, but execution continued.'
        }
    }
}