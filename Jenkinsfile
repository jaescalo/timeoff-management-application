pipeline {
  agent any

  environment {
      working_dir = 'timeoff-management-application'
  }

  stages {
    stage ("GitHub Checkout") {
      steps {
        echo "Step 1: Checkout Git"
        checkout([
          $class: 'GitSCM',
          branches: [[name: '*/master']],
          doGenerateSubmoduleConfigurations: false,
          extensions: [
            [$class: 'RelativeTargetDirectory', relativeTargetDir: 'timeoff-management-application']],
          submoduleCfg: [],
          userRemoteConfigs: [
            [url: 'https://github.com/jaescalo/timeoff-management-application.git']]
        ])
      }
    }
    stage ("Test Application") {
      steps {
        echo "Step 2. Test the Application with Docker and Mocha"
        sh "source ~/.bash_profile 2> /dev/null; docker run -d --name toma timeoff nohup npm start 1>/dev/null 2>&1 &"
        sh "source ~/.bash_profile 2> /dev/null; docker exec -t toma npm test"
        sh "source ~/.bash_profile 2> /dev/null; docker stop toma"
        sh "source ~/.bash_profile 2> /dev/null; docker rm toma"
      }
    }
    stage ("Create Artifact") {
      steps {
        echo "Step 3: Create Artifact. Job: Jenkins_${JOB_NAME}-${BUILD_NUMBER}"
        sh 'tar -zcvf timeoff-management-application.tgz ./timeoff-management-application'
      }
    }
 
    stage ("Ok to deploy artifact?") {
      steps {
        timeout(time: 2, unit: "HOURS") {
          input message: 'Approve Deploy?', ok: 'Yes'
        } 
      }
    }

    stage("Upload Artifact") {
      steps {
        echo "Step 4. Upload Artifact to Jfrog Artifactory"
        rtUpload (
            serverId: 'timeoff-management-application',
            spec: '''{
                "files": [
                    {
                    "pattern": "*.tgz",
                    "target": "timeoff-management-application/"
                    }
                ]
            }''',
            buildName: 'TOMA',
        )  
      }
    }
    stage("Spin up VM") {
      steps {
        sh '''
        mv ./timeoff-management-application/Vagrantfile ./timeoff-management-application/playbook.yaml ./
        source ~/.bash_profile 2> /dev/null; vagrant up
        '''
      }
    }
  }
}