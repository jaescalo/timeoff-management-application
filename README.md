
# Release Manager for TimeOff.Management App

This excercise demo deploys the [Timeoff Management Application](https://github.com/timeoff-management/application) in a virtual infrastructure in an automated fashiOn utilizing Jenkins CI/CD.

## Requirements
* [Github](https://github.com) Repository forked from the official [Timeoff Management Application](https://github.com/timeoff-management/application) repository.
* [Jenkins](https://www.jenkins.io/download/)
* [Docker](https://docs.docker.com/get-docker/)
* [JFrog Artifactory Cloud](https://jfrog.com/artifactory/start-free/#saas)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads )
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#from-pip)

## The Set Up
Most of the tools need to be locally installed for this demo with the exception of GitHub and JFrog which are available in the cloud.

### Jenkins CI/CD
Requires the "Artifactory plugin" to upload and download artifacts to JFrog cloud repositories.
The pipeline code is available in the Jenkinsfile. It follows these steps:
1. Checkout from the forked Github repository
2. Tests the application with mocha (part of the npm project). The test environment will run in a Docker container.
3. Once all the tests pass the code is good and the artifact is created.
4. The pipeline will pause here (for demo purposes) until someone approves the deployment.
5. The artifact is uploaded to the Artifactory.
6. A virtual machine is spinned up in VirtualBox through Vagrant. Vagrant in turn will use Ansible as the provisioning tool to deploy the application and all the requirements.


### Docker
A previously generated Docker image is available to Jenkins for running the tests. This image is built based on the Dockerfile. The flow is as follows:
1. Builds an image based on Ubuntu 20.10
2. Installs all the dependencies (nodejs, npm, sqlite, phantomjs).

To locally generate the image
'''
docker build --tag timeoff:latest .
'''

This step is not part of the Jenkins pipeline but can be integrated in next releases.

From Jenkins CICD the start and test application commands are executed and then a cleanup is performed.

'''
docker run -d --name toma timeoff nohup npm start 1>/dev/null 2>&1 &
docker exec -it toma npm test
docker stop toma
docker rm toma
'''
### JFrog Artifactory
An online account is required as well as a repository for the artifacts. Steps 4 & 5 are part of the Jenkins Pipeline.
1. In JFrog Artifactory create a new npm repository.
2. In Jenkins install the “Artifactory” Plugin.
3. In Jenkins -> Manage Jenkins -> Configure System add the Artifactory server created in step one. Remember to append /artifactory to the URL.
4. Create the *.tgz artifact which contains all the code.
5. Upload the artifact to JFrog Artifactory.

### Vagrant
A locally ubuntu-20.10 box must be downloaded and available (for the sake of time during the demo).
From the Vagrantfile the following steps take place
1. Builds an image based on Ubuntu 20.10
2. Opens port 3000 (default port for the app)
3. Uses Ansible for provisioning.

This step is striggered from Jenkins by submitting:

'''
vagrant up
'''

### Ansible
Ansible's playbook.yaml contains the instructions to provision the virtual machine deployed through vagrant.
1. Installs all the dependencies (nodejs, npm, sqlite, phantomjs).
2. Downloads the artifact from JFrog and unpacks it.
3. Install the application.
4. Executes the application.

At this point open a browser and point it to http://localhost:3000/