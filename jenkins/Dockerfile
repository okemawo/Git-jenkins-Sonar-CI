FROM jenkins/jenkins

# install maven 
USER root
RUN apt-get update && apt-get install -y maven

# disable setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# set configuration as code
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

# copy configuration as code
COPY casc.yaml /var/jenkins_home/casc.yaml

# Define environment variables
ENV SONAR_SCANNER_VERSION=4.6.2.2472 
ENV SONAR_SCANNER_HOME=/opt/sonar-scanner

# Switch to temp folder
WORKDIR /tmp

# Download and extract sonar scanner
RUN curl --create-dirs -sSLo /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip \
    && unzip /tmp/sonar-scanner.zip -d /opt/ \
    && mv /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux ${SONAR_SCANNER_HOME} \
    && rm /tmp/sonar-scanner.zip

# Update PATH
ENV PATH=${PATH}:${SONAR_SCANNER_HOME}/bin

# Switch back to the home directory
WORKDIR /home