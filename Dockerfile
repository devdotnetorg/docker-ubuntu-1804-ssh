########################
# Official Image Ubuntu with sshd
# Allow SSH connection to the container
# Installed mc,htop
########################
ARG build_name_image
#
FROM ubuntu:${build_name_image}
MAINTAINER DevDotNet.Org <anton@devdotnet.org>
LABEL maintainer="DevDotNet.Org <anton@devdotnet.org>"

#Base
# Set the locale
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get update &&  \
	apt-get install -y locales && \
	locale-gen en_US.UTF-8 && \
	update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
	dpkg-reconfigure --frontend noninteractive locales

#Main
#Folder Data
VOLUME /data
#port SSH
EXPOSE 22/tcp
# Needed by scripts
ENV PASSWORD=123456

#Setup mc,htop,openssh-server
RUN apt-get install -y mc htop openssh-server

#Clear
RUN apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{cache,log}/ && \
    rm -rf /var/lib/apt/lists/*.lz4 && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /usr/share/doc/ && \
    rm -rf /usr/share/man/

#Run
ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
