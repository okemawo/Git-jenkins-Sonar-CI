#!/bin/bash

# Prompt for project name
read -p "Enter project name: " project_name

# Prompt for project key name
read -p "Enter project key name: " project_key_name

# default username and password for sonarqube
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="admin"

# create a docker network
docker network create deployment-network

# build the docker image from sonarqube directory
docker build -t okemawo1/sonarqube-deployment sonarqube

# run the docker container
docker run --network=deployment-network -d --rm --name sonar -p 9000:9000 okemawo1/sonarqube-deployment

# sleep for 100 sec to enable sonarqube sever to be setup
echo "SonarQube is Starting ....."
sleep 100

# curl the sonarqube url with the new user credentials to generate an api key
api_key=$(curl -u $ADMIN_USERNAME:$ADMIN_PASSWORD -X POST "http://localhost:9000/api/user_tokens/generate?name=jenkins" | jq -r '.token')

# sonar url variable 
sonar_url="http://sonar:9000"

# print out the api key
echo "SonarQube API Key: $api_key"

# create a new project in sonarqube
curl -u $api_key: -X POST "http://localhost:9000/api/projects/create?name=$project_name&project=$project_key_name"

# build the ansible deployment container
docker build -t okemawo1/petclinic petclinic

docker run --rm -d --name petclinic \
    --network=deployment-network \
    -p 9090:9090 \
    okemawo1/petclinic

# build the docker image from jenkins directory
docker build -t okemawo1/jenkins-deployment jenkins

# run the docker container
docker run --network=deployment-network -d --rm --name jenkins \
    -e SONAR_PROJECT_KEY=$project_key_name \
    -e .SONAR_PROJECT_NAME=$project_name \
    -e SONAR_URL=$sonar_url \
    -e SONAR_TOKEN=$api_key \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker \
    okemawo1/jenkins-deployment
    # -p 9090:9090 \
# docker run  -d -p 8080:8080 jenkins/jenkins

# sleep for 20 sec to enable jenkins sever to be setup
echo "Jenkins is Starting ....."
sleep 20

# echo url to access jenkins blue ocean
echo "Jenkins URL: http://localhost:8080/blue"

# echo url to access jenkins
echo "Jenkins URL: http://localhost:8080"

# echo url to access sonarqube
echo "SonarQube URL: http://localhost:9000"