pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm ci'
            }
        }

        stage('Build Angular') {
            steps {
                bat 'npm run build-test'
            }
        }

        stage('Backup IIS') {
            steps {
                powershell '.\\deployment\\Backup.ps1'
            }
        }

        stage('Deploy to IIS') {

            steps {
                powershell '.\\deployment\\Deploy.ps1'
            }

            post {

                success {
                    echo 'Deployment Successful'
                }

                failure {
                    echo 'Deployment Failed'
                    powershell '.\\deployment\\Rollback.ps1'
                }

            }

        }

    }

    post {

        success {
            echo 'Pipeline Completed Successfully'
        }

        failure {
            echo 'Pipeline Failed'
        }

    }

}