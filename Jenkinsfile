pipeline {
    agent { label 'linux' } // Forces the build to run on your local machine

    stages {
        stage('Checkout') {
            steps {
                // Jenkins uses the credentials you selected in the UI
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                // Tagging with Build ID for better traceability
                sh "docker build -t java-petclinic:latest -t java-petclinic:${env.BUILD_ID} ."
            }
        }

        stage('Deploy (Homelab)') {
            steps {
                // Using docker-compose ensures the networking we fixed earlier remains intact
                sh 'docker compose down --remove-orphans'
                sh 'docker compose up -d'
            }
        }
    }

    post {
        success {
            echo "Successfully deployed Build #${env.BUILD_ID} to tuongnm-acer"
        }
        failure {
            echo "Build failed. Check the console output."
        }
    }
}