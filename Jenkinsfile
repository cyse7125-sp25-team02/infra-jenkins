pipeline {
    agent any
    
    options {
        timeout(time: 15, unit: 'MINUTES')
    }
    
    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'action', value: '$.action'],
                [key: 'pull_request_number', value: '$.pull_request.number'],
                [key: 'pull_request_sha', value: '$.pull_request.head.sha']
            ],
            causeString: 'PR $pull_request_number $action',
            token: 'github-token',
            regexpFilterText: '$action',
            regexpFilterExpression: '(opened|reopened|synchronize)'
        )
    }
    
    environment {
        TF_IN_AUTOMATION = 'true'
        TF_INPUT = 'false'
    }
    
    stages {
        stage('Checkout') {
            steps {
                script {
                    def isPR = env.pull_request_number?.trim()
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: isPR ? "origin/pr/${pull_request_number}/head" : 'master']],
                        extensions: [[$class: 'CleanBeforeCheckout']],
                        userRemoteConfigs: [[
                            url: "https://github.com/cyse7125-sp25-team02/infra-jenkins.git",
                            credentialsId: "github-credentials",
                            refspec: isPR ? '+refs/pull/*/head:refs/remotes/origin/pr/*/head' : '+refs/heads/*:refs/remotes/origin/*'
                        ]]
                    ])
                }
            }
        }
        
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
                if (env.pull_request_number) {
                    def status = currentBuild.result ?: 'SUCCESS'
                    def statusEmoji = status == 'SUCCESS' ? '✅' : '❌'
                    
                    withCredentials([string(credentialsId: "github-token", variable: 'GITHUB_TOKEN')]) {
                        try {
                            def commentBody = """**Terraform Validation Results**
- Status: ${statusEmoji} ${status}
- Build Number: #${env.BUILD_NUMBER}
- Console Log: ${env.BUILD_URL}"""

                            def jsonBody = groovy.json.JsonOutput.toJson([body: commentBody])
                            writeFile file: 'comment.json', text: jsonBody
                            
                            sh """#!/bin/bash
                                set -e
                                curl -sS -X POST \\
                                    -H 'Authorization: token '\$GITHUB_TOKEN \\
                                    -H 'Accept: application/vnd.github.v3+json' \\
                                    'https://api.github.com/repos/cyse7125-sp25-team02/infra-jenkins/issues/'${env.pull_request_number}'/comments' \\
                                    -d @comment.json
                            """
                        } catch (Exception e) {
                            echo "Failed to post GitHub comment: ${e.getMessage()}"
                        } finally {
                            sh 'rm -f comment.json || true'
                            deleteDir()
                        }
                    }
                } else {
                    echo "Skipping GitHub comment - not a PR build"
                    deleteDir()
                }
            }
        }
    }
}
