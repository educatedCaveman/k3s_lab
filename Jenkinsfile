pipeline {
    agent any 

    environment {
        ANSIBLE_REPO = '/var/lib/jenkins/workspace/ansible_master'
        WEBHOOK = credentials('JENKINS_DISCORD')
        PORTAINER_DEV_WEBHOOK = credentials('PORTAINER_WEBHOOK_DEV_HOMER')
        PORTAINER_PRD_WEBHOOK = credentials('PORTAINER_WEBHOOK_PRD_HOMER')
    }

    //triggering periodically so the code is always present
    // run every friday at 3AM
    triggers { cron('0 3 * * 5') }

    stages {
        // deploy code to lv-426.lab, when the branch is 'dev_test'
        stage('deploy dev code') {
            when { branch 'dev_test' }
            steps {
                // deploy configs to DEV
                echo 'deploy docker config files (DEV)'
                sh 'ansible-playbook deploy.yml --extra-vars "branch=dev_test dir=dev-test"'
            }
        }

        // deploy code to sevastopol, when the branch is 'master'
        stage('deploy prd code') {
            when { branch 'master' }
            steps {
                // deploy configs to PRD
                echo 'deploy docker config files (PRD)'
                // sh 'ansible-playbook deploy.yml --extra-vars "branch=master dir=production"'
                sh 'ansible-playbook deploy.yml --extra-vars "branch=master dir=dev-test"'
            }
        }

    }
    post {
        always {
            discordSend \
                description: "${JOB_NAME} - build #${BUILD_NUMBER}", \
                // footer: "Footer Text", \
                // link: env.BUILD_URL, \
                result: currentBuild.currentResult, \
                // title: JOB_NAME, \
                webhookURL: "${WEBHOOK}"
        }
    }
}

