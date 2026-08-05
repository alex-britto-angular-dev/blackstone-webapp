pipeline {
    agent any

    stages {
        /* stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm ci'
            }
        } */

        stage('Checkout & Install Dependencies') {
            steps {
                checkout scm
                bat 'npm ci'
            }
        }

        /* stage('Check Node Version') {
            steps {
                bat '''
                echo ===== NODE INFO =====
                node -v
                npm -v
                where node
                '''
            }
        } */

        stage('ESLint') {
            /* steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    bat 'npm run lint'
                }
            } */

            steps {
                bat 'npm run lint'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                //catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    script {
                        def scannerHome = tool 'SonarScanner'

                        withSonarQubeEnv('LocalSonar') {
                            bat """
                            "${scannerHome}\\bin\\sonar-scanner.bat" ^
                            -Dsonar.projectKey=blackstone-webapp ^
                            -Dsonar.projectName=Blackstone-WebApp ^
                            -Dsonar.sources=src ^
                            -Dsonar.exclusions=node_modules/**,dist/** ^
                            -Dsonar.sourceEncoding=UTF-8
                            """
                        }
                    }
                //}
            }
        }

        stage('Build Angular') {
            steps {
                bat 'npm run build'
            }
        }
        
        stage('Backup') {
            steps {
                powershell '.\\deployment\\Backup.ps1'
                powershell '''
                Write-Host "===== Available Backups ====="
                Get-ChildItem "D:\\IIS_Backup" | Select-Object Name, LastWriteTime
                '''
            }
        }

        stage('Deploy') {
            steps {
                powershell '.\\deployment\\Deploy.ps1'
            }

            post {
                failure {
                    echo 'Deployment Failed. Starting Rollback...'
                    powershell '.\\deployment\\Rollback.ps1'
                }

                success {
                    echo 'Deployment Successful.'
                }
            }
        }

        stage('Install Playwright Browsers') {
            steps {
                bat 'npx playwright install'
            }
        }

        stage('Playwright Tests') {
            steps {
                bat 'npx playwright test'
            }

            post {
                success {
                    echo 'Playwright Tests Passed.'
                }

                failure {
                    echo 'Playwright Tests Failed. Starting Rollback...'
                    powershell '.\\deployment\\Rollback.ps1'

                    // Rollback successful ஆன பிறகும் build FAILED ஆக mark ஆகும்
                    error('Playwright tests failed. Deployment rolled back.')
                }

                always {
                    publishHTML([
                        allowMissing: true,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'playwright-report',
                        reportFiles: 'index.html',
                        reportName: 'Playwright Report'
                    ])
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline Completed Successfully.'
        }

        unstable {
            echo 'Pipeline completed with warnings (ESLint/SonarQube/npm audit issues).'
        }

        failure {
            echo 'Pipeline Failed.'
        }
    }
}


/* Checkout & Install
        ↓
ESLint
        ↓
SonarQube
        ↓
Build
        ↓
Backup IIS
        ↓
Deploy IIS
        ↓
Playwright Tests
             │
      ┌──────┴──────┐
      │             │
   PASS          FAIL
      │             │
      │       Rollback.ps1
      │             │
   Success       Pipeline Failed */