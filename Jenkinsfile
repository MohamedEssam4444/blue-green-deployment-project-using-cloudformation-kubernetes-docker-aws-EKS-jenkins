pipeline {
    agent any
    stages {
      stage('Lint HTML') {
        steps {
          sh 'tidy -q -e *.html'
        }
      }
      stage('build docker image'){
        steps {
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
            sh '''
              docker build -t sidiali/capstone_repo:capstone_app .
             '''
            }
           }
          }   
      stage('push docker image to dockerhub repository'){
        steps {
          withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]){
             sh '''
               docker login -u $DOCKER_USERNAME 
               docker push sidiali/capstone_repo:capstone_app 
               '''
                }
               }
              }   
       stage('create kubeconfig file') {
             steps {
                 withAWS(region:'us-east-2',credentials:'MyCredentials') {
                 sh '''
                      kubectl config use-context arn:aws:eks:us-east-2:128971627436:cluster/jenkinstest
                   '''           }            
 }
      }
         stage('create replication controller for blue app') {
             steps {
                 withAWS(region:'us-east-2',credentials:'MyCredentials') {
                 sh '''
                      kubectl apply -f ./blue-replication-controller.yaml
                   '''         
                   }    
                   }
                   }
          stage('create replication controller for green app') {
             steps {
                 withAWS(region:'us-east-2',credentials:'MyCredentials') {
                 sh '''
                      kubectl apply -f ./green-replication-controller.yaml
                   '''           }            
 }
      }
          stage('create service for blue app and make loadbalancer point to it') {
             steps {
                 withAWS(region:'us-east-2',credentials:'MyCredentials') {
                 sh '''
                      kubectl apply -f ./blue-service.yaml
                   '''           }            
 }
}
          stage('Sanity check') {
                    steps {
                        input "Does the staging environment look ok?"
                    }
                }
         stage('create service for green app and make loadbalancer point to it') {
             steps {
                 withAWS(region:'us-east-2',credentials:'MyCredentials') {
                 sh '''
                      kubectl apply -f ./green-service.yaml
                   '''           }            
 }

    }
}
}
