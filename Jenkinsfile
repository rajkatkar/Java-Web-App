pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        GroupId = readMavenPom().getGroupId()
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/yourrepo/project.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Get Nexus IP') {
            steps {
                script {
                    def nexus_ip = sh(
                        script: "cd terraform && terraform output -raw nexus_public_ip",
                        returnStdout: true
                    ).trim()

                    env.NEXUS_IP = nexus_ip
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {

                    nexusArtifactUploader artifacts: [[
                        artifactId: "${ArtifactId}",
                        classifier: '',
                        file: "target/${ArtifactId}-${Version}.war",
                        type: 'war'
                    ]],
                    credentialsId: 'nexus',
                    groupId: "${GroupId}",
                    nexusUrl: "${env.NEXUS_IP}:8081",
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: 'MyLab-RELEASE',
                    version: "${Version}"
                }
            }
        }

    }
}
