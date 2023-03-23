// https://github.com/vikash-kumar01/demo-counter-app.git
pipeline {
    agent any
    // installed the maven jenkins,
    // maven plugin install, global tool configuration , name : 3.6.3 , version -> Saveit
    tools {
        maven '3.6.3'
    }
    stages {
        stage ('Git Checkout'){
            steps {
                git 'https://github.com/formycore/jenkins_nexus_sonar.git'
            }
        }
        stage ('Test'){
            steps {
                sh 'mvn test'
            }
        }
        stage('Integration Test'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage ('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage ('Static Code Analysis'){
            steps {
                script {
            withSonarQubeEnv(credentialsId: 'secreta') {
                sh 'mvn clean package sonar:sonar'
            }
            }
            }
        }
        stage ('Quality Gate Analysis'){
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'secreta'
// here we will get error checking for the sonarqube task some <id>
// we need to create a sonarqube webhook
//sonarqube -> administration -> configuration-> webhooks -> Name: jenkins_webhook
// URL: http://<jenkins-url:8080>/sonarqube-webhook/ -> save it
// re run it 
                    
                }
            }
        }
        stage ('Upload artifact to nexus'){
// here the scenario comes if the developer updates the code, with change in version, then we need to we need to change the 
//version here, manage plugins -> piepline-utility-steps -> check for the read pom using pipeline-utilities
// in the script section we define a variable 

            steps {
                script{
                    def readPomVersion = readMavenPom file: 'pom.xml'
                    // we are reading the pom file 
// how we will get to know this build is for snapshot or not 
// in the pom.xml file the version 1.0.0-SNAPSHOT 
// conditional statement is used, we need to switch b/w 2 repos using the keyword
// readMavenPom.version.endsWith("SNAPSHOT") ? "this repo" :(or) "this repo"
// to store the snapshot we need one more repo under nexus
                    def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "demoapp-snapshot": "demoapp-release"
                    // (error) artifact is already deployed with that version if it is a release (not -SNAPSHOT version)
                    // (error) Deploy the same version of a release artifact more than once to a release repository

                    nexusArtifactUploader artifacts: [
                        [
                            artifactId: 'springboot', 
                            classifier: '', 
                            file: 'target/Uber.jar', 
                            type: 'jar'
                        ]
                            ],
                            credentialsId: 'nexus-auth',
                            groupId: 'com.example', 
                            nexusUrl: '34.29.226.153:8081', 
                            nexusVersion: 'nexus3', 
                            protocol: 'http', 
                            repository: "${nexusRepo}",
                            //version: '1.0.0'
                            version: "${readPomVersion.version}"
                            // from the line no 57 def we will get the version dynamically
                      
                }
            }
        }
    }
}