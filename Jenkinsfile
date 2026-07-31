pipeline {

    agent any

    tools {
        sonarQube 'SonarScanner'
    }

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

        stage('SonarQube Analysis') {
            steps {

                script {

                    def scannerHome = tool 'SonarScanner'

                    withSonarQubeEnv('LocalSonar') {

                        bat """
                        "${scannerHome}\\bin\\sonar-scanner.bat" ^
                        -Dsonar.projectKey=blackstone-webapp ^
                        -Dsonar.projectName=Blackstone-WebApp ^
                        -Dsonar.sources=src ^
                        -Dsonar.sourceEncoding=UTF-8
                        """

                    }

                }

            }
        }

        stage('Build Angular') {
            steps {
                bat 'npm run build'
            }
        }

        stage('Backup IIS') {
            steps {
                powershell '.\\deployment\\Backup.ps1'
            }
        }

        stage('Deploy IIS') {
            steps {
                powershell '.\\deployment\\Deploy.ps1'
            }

            post {

                failure {
                    powershell '.\\deployment\\Rollback.ps1'
                }

            }
        }

    }

}