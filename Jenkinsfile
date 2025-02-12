pipeline {
    agent any
    
    options {
        timeout(time: 15, unit: 'MINUTES')
    }
    
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT = 'false'
        GITHUB_TOKEN = credentials('github-token')
    }
    
    stages {
        stage('Terraform Init') {
            steps {
                sh 'terraform init -no-color'
            }
        }
        
        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check -no-color'
            }
        }
        
        stage('Terraform Validate') {
            steps {
                sh 'terraform validate -no-color'
            }
        }
    }
    
    post {
        always {
            script {
                if (env.CHANGE_ID) {
                    def status = currentBuild.result ?: 'SUCCESS'
                    def statusEmoji = status == 'SUCCESS' ? '✅' : '❌'
                    
                    def payload = """
                    {
                        "body": "**Terraform Validation Results**\\n- Status: ${statusEmoji} ${status}\\n- Build Number: ${env.BUILD_NUMBER}\\n- Console Log: ${env.BUILD_URL}"
                    }
                    """
                    
                    sh """
                        curl -X POST \
                        -H 'Authorization: token ${GITHUB_TOKEN}' \
                        -H 'Accept: application/vnd.github.v3+json' \
                        https://api.github.com/repos/${env.CHANGE_OWNER}/${env.CHANGE_REPO}/issues/${env.CHANGE_ID}/comments \
                        -d '${payload}'
                    """
                }
                cleanWs()
            }
        }
    }
}
