FROM ubuntu:14.04.1
USER root
MAINTAINER Manasi

RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -y update

RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get -y install oracle-java8-installer

RUN apt-get install apt-transport-https 
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
RUN apt-get -y update
RUN apt-get -y install lxc-docker
RUN echo DOCKER_OPTS=\"-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock\" | sudo tee -a /etc/default/docker

RUN wget http://download.go.cd/gocd-deb/go-agent-14.4.0-1356.deb
RUN apt-get -y install unzip
RUN dpkg -i go-agent-14.4.0-1356.deb
RUN sed -i 's/DAEMON=Y/DAEMON=N/g' /etc/default/go-agent
RUN sudo adduser go sudo
RUN echo %go ALL=NOPASSWD:ALL > /etc/sudoers.d/go
RUN rm -rf go-agent-14.4.0-1356.deb
RUN apt-get -y install git
RUN apt-get install -y python-pip
RUN pip install awscli

USER go
RUN sudo mkdir /opt/data
RUN sudo chown -R go:go /opt/data
VOLUME /opt/data
ADD entrypoint.sh /opt/entrypoint.sh
RUN sudo chmod +x /opt/entrypoint.sh
CMD ["/opt/entrypoint.sh"]
