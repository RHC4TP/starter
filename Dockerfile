## Simple webserver container 
# Using RHEL 7 base image and Apache Web server

# Pull the rhel image from the local repository
FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER <yanai@example.com>

### Add Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels#####
#Labels
LABEL  name="AvocadoSystems/avocado-demo" \
       vendor="Avocado Systems" \
       version="1.2" \
       release="1" \
       com.redhat.component="rhel-server-docker" \
       authoritative-source-url="registry.access.redhat.com" \
       distribution-scope="public" \
       description="Demo container will embed the ASP plugins integration ..." \
       io.k8s.display-name="Red Hat Enterprise Linux 7" \
       summary="Avocado Systems Application-Security-Platform for Applications" \
       vcs-type="git" \
       vcs-ref="b7f83830183f71d08b6d758479417bb5437877a9" \
       architecture="x86_64" \
       io.openshift.tags="base rhel7" \
       # build-date="2017-12-21T15:47:06.130692" \
       com.redhat.build-host="gj-rhel74.localdomain" 


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
