pipeline {
  agent any
  environment {
    PROJECT = 'analog-fastness-472715-j6'
    IMAGE = "gcr.io/${env.PROJECT}/customer-loader:${env.BUILD_NUMBER}"
    SA_KEY = credentials('gcr-service-account-key')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build Image') {
      steps {
        sh 'docker build -t ${IMAGE} ./scripts/loader'
      }
    }
    stage('Authenticate GCR') {
      steps {
        sh 'echo "${SA_KEY}" > /tmp/key.json'
        sh 'gcloud auth activate-service-account --key-file=/tmp/key.json'
        sh 'gcloud auth configure-docker --quiet'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push ${IMAGE}'
      }
    }
  }
}
