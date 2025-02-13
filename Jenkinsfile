pipeline {
    agent any
    
    options {
        timeout(time: 15, unit: 'MINUTES')
    }
    
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT = 'false'
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

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate -no-color'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
    }
}
