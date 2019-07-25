FROM alpine:latest

ARG BUILD_DATE

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="TimeMachine - Samba" \
  org.label-schema.description="TimeMachine server using Samba protocol." \
  org.label-schema.vcs-url="https://github.com/odarriba/docker-timemachine" \
  org.label-schema.schema-version="1.0"

##################
##   BUILDING   ##
##################

WORKDIR /

RUN apk update && \
  apk upgrade && \
  apk add --no-cache \
  bash \
  samba-server \
  samba-common-tools \
  samba-winbind \
  supervisor

RUN mkdir -p /timemachine && \
  mkdir -p /etc/samba && \
  mkdir -p /var/log/supervisor

ADD bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ADD bin/add-account /usr/bin/add-account
ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD config/smb.conf /etc/samba/smb.conf

EXPOSE 137/UDP 138/UDP 139/TCP 445/TCP

VOLUME ["/timemachine"]

CMD ["/entrypoint.sh"]
