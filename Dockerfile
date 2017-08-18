FROM centos:7
MAINTAINER Karl Stoney <me@karlstoney.com> 

ENV TERM=xterm-256color

ENV GCLOUD_VERSION=167.0.0
ENV CLOUDSDK_INSTALL_DIR /usr/lib64/google-cloud-sdk
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1
COPY gcloud.repo /etc/yum.repos.d/
RUN mkdir -p /etc/gcloud/keys

RUN yum -y -q update && \
		yum -y -q remove iputils && \
		yum -y -q install epel-release which unzip wget && \ 
    yum -y -q install google-cloud-sdk-$GCLOUD_VERSION* && \
		yum -y -q install python-pip && \
    yum -y -q clean all

# Disable google cloud auto update... we should be pushing a new agent container
RUN gcloud config set --installation component_manager/disable_update_check true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set core/disable_usage_reporting true

RUN cd /opt && \
		wget -q https://github.com/Stono/G-Scout/archive/master.zip && \
		unzip master.zip && \
		rm master.zip && \
		mv G-Scout-master gscout && \
		cd gscout && \
		pip install -r requirements.txt

WORKDIR /opt/gscout
VOLUME /root
COPY go.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/go.sh"]
