# shut down the sonarqube container
docker stop sonar
docker stop jenkins
docker stop petclinic
docker network rm deployment-network