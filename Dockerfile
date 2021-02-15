# -------------------------------------------------------------------
# Dockerfile for Ubuntu 20.10 and all dependencies for required to 
# test the timeoff-management-application with mocha
#
# Instructions:
# =============
# 1. Start the container with the app running
#    docker run -di --name toma timeoff nohup npm start 1>/dev/null 2>&1 &
#
# 2. Execute the npm test
#	 docker exec -it --name toma npm test
# --------------------------------------------------------------------
FROM ubuntu:20.10

EXPOSE 3000

USER root
RUN apt update
RUN apt upgrade -y
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y sqlite3
RUN apt install -y wget
    

WORKDIR /app/timeoff-management
ADD  . /app/timeoff-management

RUN npm install

RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/
RUN ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/
