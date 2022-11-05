pipeline {
    agent any
    environment {
      DB_NAME="netology"
      DB_USER="dotsenkois"
      DB_PASSWORD="12345678"
      HOST="192.168.10.100"
      PORT="5432"
      MAJOR_VER="0"
      MINOR_VER="0"
      REGISTRY_ID="crpf83jkr9h92qmose30"
    }
    options {
        skipStagesAfterUnstable()
    }

    stages {
        stage('Prepare') {
            steps {
                git branch: 'main', credentialsId: '1', url: 'https://github.com/dotsenkois/diploma-web-app'
            }
        }
        
        stage('Build') {
            steps {
                echo "${BUILD_NUMBER}"
                sh '''
                docker-compose up &
                '''
                sleep 180
            }
        }
        
        stage('Test frontend') {
            steps {
                sh '''
                if [ 200 != $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081) ]; then exit 1; fi
                '''
            }
        }

        stage('Test backend') {
            steps {
                sh '''
                if [ 200 != $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000) ]; then exit 1; fi
                '''
            }
        }
        
        stage('Stop containers') {
            steps {
                sh '''
                docker ps
                docker images
                docker-compose stop
                '''
            }
          }
        stage('Tag image') {
            steps {
                sh 'docker tag webapp_backend cr.yandex/${REGISTRY_ID}/diploma-web-app_backend:${MAJOR_VER}.${MINOR_VER}.${BUILD_NUMBER}'
                sh 'docker tag webapp_frontend cr.yandex/${REGISTRY_ID}/diploma-web-app_frontend:${MAJOR_VER}.${MINOR_VER}.${BUILD_NUMBER}'
            }
        }
        
        stage('Push to registry') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh 'docker push'
            }
        }
        
        stage('Trigger kubernetes') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                echo 'wad'
            }    
        }
    }
    post {
        always {
            sh 'docker rm -vf $(docker ps -aq)'
            sh 'docker rmi -f $(docker images -aq)'
        }

    }



    
}