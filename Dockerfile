FROM alpine:latest
MAINTAINER Óscar de Arriba <odarriba@gmail.com>

##################
##   BUILDING   ##
##################

# Versions to use
ENV netatalk_version 3.1.8

WORKDIR /tmp

# Prerequisites
RUN apk update && \
    apk upgrade && \
    apk add --nocache \
      avahi \
      libldap \
      libgcrypt \
      python \
      dbus \
      dbus-glib \
      py-dbus \
      linux-pam \
      cracklib \
      db \
      libevent \
      file \
      openssl && \
    apk add --nocache --virtual .build-deps \
      build-base \
      autoconf \
      automake \
      libtool \
      avahi-dev \
      libgcrypt-dev \
      linux-pam-dev \
      cracklib-dev \
      db-dev \
      libevent-dev && \
    # Fake chfn
    ln -s -f /bin/true /usr/bin/chfn && \
    # Compile netatalk
    wget http://prdownloads.sourceforge.net/netatalk/netatalk-${netatalk_version}.tar.gz && \
    tar xvf netatalk-${netatalk_version}.tar.gz && \
    cd netatalk-${netatalk_version} \
    CFLAGS="-Wno-unused-result -O2" ./configure \
      --prefix=/usr \
      --localstatedir=/var/state \
      --sysconfdir=/etc \
      --sbindir=/usr/bin \
      --enable-silent-rules \
      --with-cracklib \
      --with-cnid-cdb-backend \
      --enable-pgp-uam \
      --with-acls && \
    make && \
    make install && \
    # Remove dev dependencies
    cd /tmp && \
    rm -rf netatalk-${netatalk_version} netatalk-${netatalk_version}.tar.gz && \
    apk del .build-deps

RUN  mkdir -p /timemachine

# Create the log file
RUN touch /var/log/afpd.log

ADD entrypoint.sh /entrypoint.sh

EXPOSE 548 636

VOLUME ["/timemachine"]

CMD ["entrypoint.sh"]
