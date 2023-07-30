FROM centos:7

#install httpd (web server)
RUN yum -y update
RUN yum -y install httpd httpd-tools

# home page copy from /home/index.html
COPY index.html /var/www/html/index.html

EXPOSE 80

#start web server
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]


on jenkins:
----------
----static----
docker image build -t myimage:v1 .
docker image tag myimage:v1 <docker a/c>/myimage:v1
docker image push <docker a/c>/myimage:v1


----dynamic----
docker image build -t $JOB_NAME:v1.$BUILD_ID
docker image tag $JOB_NAME:v1.$BUILD_ID <docker a/c>/$JOB_NAME:v1.$BUILD_ID
docker image push <docker a/c>/$JOB_NAME:v1.$BUILD_ID
------
docker image tag $JOB_NAME:v.$BUILD_ID <docker a/c>/$JOB_NAME:latest
docker image push <docker a/c>/$JOB_NAME:latest

----To delete useles image from ansible 
docker image rmi $JOB_NAME:v1.$BUILD_ID <docker a/c>/$JOB_NAME:v1.$BUILD_ID <docker a/c>/$JOB_NAME:latest


on Ansible:
----------
vi docker.yaml
-hosts: <docker host tag name>
 tasks:
   -shell: docker run -itd --name testcon -p 8080:80 myimage:v1

After jenkins dynamic ... ansible task also be dynamic.....
------------------------------
vi docker.yaml
-hosts: <docker host tag name>
 tasks:
   -shell: docker run -itd --name testcon -p 8080:80 myimage:v1

----------------------------------------

vi docker.yaml
-hosts: <docker host tag name>
 tasks:
   -name: stop container
    shell: docker container stop testcon
   -name: romeve container
    shell: docker container rm testcon
   -name: remove docker image
    shell: docker image rmi <docker a/c>/myimage
   -name: create new container
   -shell: docker run -itd --name mycontainer -p 8080:80 myimage:v1
