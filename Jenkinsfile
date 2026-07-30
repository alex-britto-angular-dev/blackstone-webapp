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
                bat 'npm run build'
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                @echo off

                echo ===== Deploying to IIS =====

                if not exist "C:\\inetpub\\wwwroot" (
                    mkdir "C:\\inetpub\\wwwroot"
                )

                xcopy "dist\\blackstone-starter\\*" "C:\\inetpub\\wwwroot\\" /E /I /Y

                echo ===== Deployment Completed =====
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }
    }
}