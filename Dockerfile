FROM docker.io/library/ubuntu:23.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install samba krb5-config winbind smbclient iproute2 openssl ldap-utils

RUN rm /etc/krb5.conf /etc/samba/smb.conf
COPY ./scripts /opt/scripts

HEALTHCHECK  --retries=3 --start-period=5s --interval=15s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

CMD /opt/scripts/start.sh
