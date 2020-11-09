########################
# Official Image Ubuntu with sshd
# Allow SSH connection to the container
# Installed: openssh-server, mc,htop,
# for net: ping, traceroute, telnet, host,
# nslookup, iperf, nmap
########################
#
FROM ubuntu:18.04
MAINTAINER DevDotNet.Org <anton@devdotnet.org>
LABEL maintainer="DevDotNet.Org <anton@devdotnet.org>"

#Base
# Set the locale

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Password for ssh
ENV PSWD=123456

#Copy to image
COPY copyables /

#Install
RUN apt-get update \
	&& apt-get install -y mc htop openssh-server \
#Net utils
	&& apt-get install -y iputils-ping traceroute telnet dnsutils iperf nmap \
#Cleaning
	&& apt-get autoclean -y \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/{cache,log}/ \
	&& rm -rf /var/lib/apt/lists/*.lz4 \
	&& rm -rf /var/log/* \
	&& rm -rf /tmp/* /var/tmp/* \
	&& rm -rf /usr/share/doc/ \
	&& rm -rf /usr/share/man/ \
	&& chmod +x /docker-entrypoint.sh
	
#Main
#Folder Data
VOLUME /data

#port SSH
EXPOSE 22/tcp

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]