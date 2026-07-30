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
                echo Cleaning IIS folder...

                del /Q "C:\\inetpub\\wwwroot\\*.*"
                for /D %%x in ("C:\\inetpub\\wwwroot\\*") do rmdir /S /Q "%%x"

                echo Copying Angular build...

                xcopy "dist\\blackstone-starter\\*" "C:\\inetpub\\wwwroot\\" /E /Y /I

                echo Deployment completed.
                '''
            }
        }
    }
}