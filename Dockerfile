## Simple webserver container 
# Using RHEL 7 base image and Apache Web server

# Pull the rhel image from the local repository
FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER <yanai@example.com>

LABEL name="Nexus Repository Manager" \
      vendor=Sonatype \
      version="3.7.1-02" \
      release="3.7.1" \
      url="https://sonatype.com" \
      summary="The Nexus Repository Manager server \
          with universal support for popular component formats." \
      run="docker run -d --name NAME \
          -p 8081:8081 \
          IMAGE" \
      stop="docker stop NAME" \
      com.sonatype.license="Apache License, Version 2.0" \
      com.sonatype.name="Nexus Repository Manager base image" \
      io.k8s.description="The Nexus Repository Manager server \
          with universal support for popular component formats." \
      io.k8s.display-name="Nexus Repository Manager" \
      io.openshift.expose-services="8081:8081" \
      io.openshift.tags="Sonatype,Nexus,Repository Manager"


### Atomic Help File - Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc

COPY help.md /tmp/help.md
COPY licenses /licenses


### Add necessary Red Hat repos here
RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms \
### Add your package needs here
    INSTALL_PKGS="golang-github-cpuguy83-go-md2man httpd" && \
    yum -y update-minimal --disablerepo "*" --enablerepo rhel-7-server-rpms --setopt=tsflags=nodocs \
      --security --sec-severity=Important --sec-severity=Critical && \
    yum -y install --disablerepo "*" --enablerepo ${REPOLIST} --setopt=tsflags=nodocs ${INSTALL_PKGS} && \

### help file markdown to man conversion
   go-md2man -in /tmp/help.md -out /help.1 && \

     yum clean all


# Install the application

#RUN yum install httpd -y

RUN echo "This container image was build on:" > /var/www/html/index.html
RUN date >> /var/www/html/index.html
EXPOSE 8080

#Start the service
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
