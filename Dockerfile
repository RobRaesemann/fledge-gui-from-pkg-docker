FROM nginx:latest

# Set FogLAMP version, distribution, and platform
ENV FLEDGE_VERSION=1.9.1
ENV FLEDGE_DISTRIBUTION=ubuntu2004
ENV FLEDGE_PLATFORM=x86_64

RUN apt update && \ 
    apt install -y wget && \ 
    wget --no-check-certificate https://fledge-iot.s3.amazonaws.com/${FLEDGE_VERSION}/${FLEDGE_DISTRIBUTION}/${FLEDGE_PLATFORM}/fledge-${FLEDGE_VERSION}_${FLEDGE_PLATFORM}_${FLEDGE_DISTRIBUTION}.tgz && \
    tar -xzvf fledge-${FLEDGE_VERSION}_${FLEDGE_PLATFORM}_${FLEDGE_DISTRIBUTION}.tgz && \
    dpkg --unpack /fledge/${FLEDGE_VERSION}/${FLEDGE_DISTRIBUTION}/${FLEDGE_PLATFORM}/fledge-gui-${FLEDGE_VERSION}.deb && \
    # remove files in the existing NGINX HTML directory
    rm -r /usr/share/nginx/html && \
    # move our FogLAMP GUI files to the NGINX HTML directory
    mv /var/www/html /usr/share/nginx && \
    # The default page from FogLAMP GUI must be renamed to index.html
    mv /usr/share/nginx/html/fledge.html /usr/share/nginx/html/index.html && \
    # Set the proper owner on our moved files
    chown -R  nginx.nginx /usr/share/nginx/html && \
    # Cleanup FogLAMP installation packages
    rm -f /*.tgz && \ 
    # You may choose to leave the installation packages in the directory in case you need to troubleshoot
    rm -rf -r /fledge && \
    # General cleanup after using apt
    apt clean -y && \
    rm -rf /var/lib/apt/lists/ && \
	  rm -rf /var/www/

EXPOSE 80

LABEL maintainer="rob@raesemann.com" \
  author="Rob Raesemann" \
  target="x86_64" \
  version="${FLEDGE_VERSION}" \
  description="FLEDGE IIoT Framework GUI"