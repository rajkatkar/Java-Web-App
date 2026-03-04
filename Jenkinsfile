pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        GroupId = readMavenPom().getGroupId()
        Name = readMavenPom().getName()
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/YOUR-REPO.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
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

        stage('Get Docker IP') {
            steps {
                script {
                    def docker_ip = sh(
                        script: "cd terraform && terraform output -raw docker_private_ip",
                        returnStdout: true
                    ).trim()

                    env.DOCKER_IP = docker_ip
                }
            }
        }

        stage('Update Ansible Inventory') {
            steps {
                sh "sed -i 's/DOCKER_IP/${env.DOCKER_IP}/g' hosts"
            }
        }

        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {

                    def NexusRepo = Version.endsWith("SNAPSHOT") ? "MyLab-SNAPSHOT" : "MyLab-RELEASE"

                    nexusArtifactUploader artifacts: [[
                        artifactId: "${ArtifactId}",
                        classifier: '',
                        file: "target/${ArtifactId}-${Version}.war",
                        type: 'war'
                    ]],
                    credentialsId: 'nexus',
                    groupId: "${GroupId}",
                    nexusUrl: 'NEXUS-IP:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: "${NexusRepo}",
                    version: "${Version}"
                }
            }
        }

        stage('Deploy using Ansible') {
            steps {
                sshPublisher(publishers: [
                    sshPublisherDesc(
                        configName: 'ansible-controller',
                        transfers: [
                            sshTransfer(
                                sourceFiles: 'download-deploy.yaml, hosts',
                                remoteDirectory: '/playbooks',
                                execCommand: 'cd playbooks && ansible-playbook download-deploy.yaml -i hosts'
                            )
                        ]
                    )
                ])
            }
        }

    }
}