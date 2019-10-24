# OpenVPN Proxy Client
#
# Based on https://github.com/schmas/docker-openvpn-proxy
# and https://github.com/ericdraken/docker-openvpn-client
#
# Version 0.0.2
#
# See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.

FROM phusion/baseimage:master
MAINTAINER Eric Draken <ericdraken@gmail.com>

# Evironment variables
ENV DEBIAN_FRONTEND=noninteractive \
    OPENVPN_USERNAME=**None** \
    OPENVPN_PASSWORD=**None** \
    OPENVPN_PROVIDER=**None**

# Update packages
RUN apt-get update && apt-get upgrade -y

# OpenVPN
RUN apt-get install -y openvpn inetutils-traceroute inetutils-ping wget curl \
    && curl -L https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz | tar -C /usr/local/bin -xzv \
    && rm -rfv dockerize-linux-amd64-v0.6.1.tar.gz

# Squid
RUN apt-get install -y squid3 \
    && mv -f /etc/squid/squid.conf /etc/squid/squid.conf.original

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enabling SSH
RUN rm -f /etc/service/sshd/down

# Enabling the insecure key permanently
RUN /usr/sbin/enable_insecure_key

# Expose ports
EXPOSE 22
EXPOSE 3128

# Volumes
VOLUME /config

# Adding utils scripts to bin
ADD bin/ /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Add configuration and scripts
ADD openvpn /etc/openvpn
RUN chmod +x /etc/openvpn/bin/* \
    && mkdir -p /etc/openvpn/up \
    && mkdir -p /etc/openvpn/down \
    && ln -s /usr/local/bin/ssh-restart /etc/openvpn/up/00-ssh-restart \
    && ln -s /usr/local/bin/my-public-ip-info /etc/openvpn/up/01-my-public-ip-info

# Running scripts during container startup
RUN mkdir -p /etc/my_init.d \
    && ln -s /etc/openvpn/bin/openvpn-setup.sh /etc/my_init.d/openvpn-setup.sh \
    && chmod +x /etc/my_init.d/*

# Add to runit
RUN mkdir /etc/service/openvpn \
    && ln -s /etc/openvpn/bin/openvpn-run.sh /etc/service/openvpn/run \
    && ln -s /etc/openvpn/bin/openvpn-finish.sh /etc/service/openvpn/finish \
    && chmod +x /etc/service/openvpn/run \
    && chmod +x /etc/service/openvpn/finish

# Squid scripts and configuration
ADD squid/ /etc/squid/
RUN chmod +x /etc/squid/squid-*.sh \
    && mkdir -p /etc/service/squid \
    && ln -s /etc/squid/squid-run.sh /etc/service/squid/run \
    && ln -s /etc/squid/squid-finish.sh /etc/service/squid/finish

ENTRYPOINT ["docker-entrypoint.sh"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]