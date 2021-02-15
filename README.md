
# Release Manager for TimeOff.Management App

This excercise demo deploys the [Timeoff Management Application](https://github.com/timeoff-management/application) in a virtual infrastructure in an automated fashiOn utilizing Jenkins CI/CD.

DIAGRAMA

## Requirements
* [Github](https://github.com) Repository forked from the official [Timeoff Management Application](https://github.com/timeoff-management/application) repository.
* [Jenkins](https://www.jenkins.io/download/)
* [Docker](https://docs.docker.com/get-docker/)
* [JFrog Artifactory Cloud](https://jfrog.com/artifactory/start-free/#saas)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads )
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



```bash
USE_CHROME=1 npm test
```

(make sure that application with default settings is up and running)

Any bug fixes or enhancements should have good test coverage to get them into "master" branch.

## Updating existing instance with new code

In case one needs to patch existing instance of TimeOff.Managenent application with new version:

```bash
git fetch
git pull origin master
npm install
npm run-script db-update
npm start
```

