FROM docker.io/library/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install samba krb5-config winbind smbclient iproute2 openssl ldap-utils

RUN rm /etc/krb5.conf /etc/samba/smb.conf
COPY ./scripts /opt/scripts

CMD /opt/scripts/start.sh
