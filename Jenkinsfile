pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install') {
            steps {
                bat 'npm ci'
            }
        }

        stage('Build') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Deploy to IIS') {
            steps {
                bat '''
                echo Cleaning IIS...

                if exist "C:\\inetpub\\wwwroot\\*" (
                    del /F /Q "C:\\inetpub\\wwwroot\\*"
                    for /D %%G in ("C:\\inetpub\\wwwroot\\*") do rmdir /S /Q "%%G"
                )

                echo Copying build files...

                xcopy "dist\\blackstone-starter\\*" "C:\\inetpub\\wwwroot\\" /E /I /Y

                echo Deployment Successful.
                '''
            }
        }

    }
}