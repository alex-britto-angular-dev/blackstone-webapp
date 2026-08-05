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

        stage('Check Node Version') {
            steps {
                bat '''
                echo ===== NODE INFO =====
                node -v
                npm -v
                where node
                '''
            }
        }

        stage('ESLint') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    bat 'npm run lint'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
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
                }
            }
        }

        /* stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            emailext(
                                to: 'angular@blackstoneshipping.com',
                                subject: "SonarQube Quality Gate Failed - ${env.JOB_NAME}",
                                body: """
                                        Project: ${env.JOB_NAME}
                                        Build Number: ${env.BUILD_NUMBER}

                                        SonarQube Quality Gate Status: ${qg.status}

                                        Build URL:
                                        ${env.BUILD_URL}
                                      """
                            )
                            error("Pipeline aborted due to SonarQube Quality Gate failure: ${qg.status}")
                        }
                    }
                }
            }
        } */

        /* stage('Dependency Security Scan') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'UNSTABLE') {
                    bat 'npm audit --audit-level=high'
                }
            }
        } */

        stage('Build Angular') {
            steps {
                bat 'npm run build'
            }
        }
        
        stage('Backup IIS') {
            steps {
                powershell '.\\deployment\\Backup.ps1'
                powershell '''
                Write-Host "===== Available Backups ====="
                Get-ChildItem "D:\\IIS_Backup" | Select-Object Name, LastWriteTime
                '''
            }
        }

        stage('Deploy to IIS') {
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

        stage('Playwright Tests') {
            steps {
                bat 'npx playwright test'
            }

            post {
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
