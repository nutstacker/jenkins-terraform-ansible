pipeline{

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY')
    }

    agent any
    stages {
        stage('checkout') {
            steps {
                
                git 'https://github.com/nutstacker/jenkins-terraform-ansible'
            }
        }  
        stage('Terraform init'){
            steps{
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan' 
                    sh 'terraform apply --auto-approve'                  
                }
                
            }
        }
        stage('invoke ansiblle-playbook'){
            steps{
                ansiblePlaybook credentialsId: 'ust-manu', disableHostKeyChecking: true, installation: 'ansible-master', inventory: 'hosts.ini', playbook: 'roles.yml'
            }
        
        }
    }
}
