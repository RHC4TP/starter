## Simple webserver container 
# Using RHEL 7 base image and Apache Web server

# Pull the rhel image from the local repository
FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER <yanai@example.com>

### Add Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels#####
LABEL name="yanai-app" \
      vendor="Yanai Testing" \
      version="1.0" \
      release="1" \
      run='docker run -d -p 8080:80 --name=yanai-app yanai-app' \
      summary="Yanai Corp's Starter app" \
      description="Starter app will do ....." 

### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc

#COPY help.md /tmp/help.md
COPY licenses /licenses


### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms \
### Add your package needs here
    INSTALL_PKGS="golang-github-cpuguy83-go-md2man httpd" && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \

### help file markdown to man conversion
#   go-md2man -in /tmp/help.md -out /help.1 && \

     yum clean all


# Install the application

#RUN yum install httpd -y

RUN echo "This container image was build on:" > /var/www/html/index.html
RUN date >> /var/www/html/index.html
EXPOSE 8080

#Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
