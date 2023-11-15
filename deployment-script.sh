#!/bin/bash

# Prompt for project name
read -p "Enter project name: " project_name

# Prompt for project key name
read -p "Enter project key name: " project_key_name


ADMIN_USERNAME="admin"
ADMIN_PASSWORD="admin"

# # Print the entered information
# echo "SonarQube username: $username"
# echo "SonarQube password: $password"
# echo "Project name: $project_name"
# echo "Project key name: $project_key_name"

# create a docker network
docker network create deployment-network

# build the docker image from sonarqube directory
docker build -t okemawo1/sonarqube-deployment sonarqube

# run the docker container
docker run --network=deployment-network -d --rm --name sonar -p 9000:9000 okemawo1/sonarqube-deployment

# wait for the container to start for 100 seconds with a loading spinner animation to indicate that sonarqube is starting
for i in {1..100}; do echo -ne '\e[34m\rSonarQube is starting please wait...  '$(printf "%0.s." {1..$i})'\e[0m'; sleep 1; done

# curl the sonarqube url with the new user credentials to generate an api key
api_key=$(curl -u $ADMIN_USERNAME:$ADMIN_PASSWORD -X POST "http://localhost:9000/api/user_tokens/generate?name=jenkins" | jq -r '.token')

git_repo='okemawo/spring-petclinic'

sonar_url="http://sonar:9000"

# print out the api key
echo "SonarQube API Key: $api_key"

# create a new project in sonarqube
curl -u $api_key: -X POST "http://localhost:9000/api/projects/create?name=$project_name&project=$project_key_name"

# build the docker image from jenkins directory
docker build -t okemawo1/jenkins-deployment jenkins

# run the docker container
docker run --network=deployment-network -d --rm --name jenkins -e SONAR_URL=$sonar_url -e SONAR_TOKEN=$api_key -p 8080:8080 okemawo1/jenkins-deployment 