FROM ubuntu:14.04
MAINTAINER Óscar de Arriba <odarriba@gmail.com>

##################
##   BUILDING   ##
##################

# Prerequisites
RUN apt-get update 
ENV DEBIAN_FRONTEND noninteractive
RUN ln -s -f /bin/true /usr/bin/chfn

# Versions to use
ENV libevent_version 2.0.22-stable
ENV netatalk_branch branch-netatalk-3-1

# Install prerequisites:
RUN apt-get -y install build-essential wget pkg-config checkinstall git avahi-daemon libavahi-client-dev libcrack2-dev libwrap0-dev autotools-dev automake libtool libdb-dev libacl1-dev libdb5.3-dev db-util db5.3-util libgcrypt11 libgcrypt11-dev libtdb-dev

# Compiling libevent
WORKDIR /usr/local/src
RUN wget https://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-${libevent_version}.tar.gz
RUN tar xfv libevent-${libevent_version}.tar.gz

WORKDIR libevent-${libevent_version}
RUN ./configure
RUN make
RUN checkinstall \
    --pkgname=libevent-${libevent_version} \
    --pkgversion=${libevent_version} \
    --backup=no \
    --deldoc=yes \
    --default --fstrans=no

# Compiling netatalk
WORKDIR /usr/local/src
RUN git clone git://git.code.sf.net/p/netatalk/code netatalk-code

WORKDIR netatalk-code
RUN git checkout ${netatalk_branch}
RUN ./bootstrap
RUN ./configure \
    --enable-debian \
    --enable-krbV-uam \
    --enable-zeroconf \
    --enable-krbV-uam \
    --enable-tcp-wrappers \
    --with-cracklib \
    --with-acls \
    --with-dbus-sysconf-dir=/etc/dbus-1/system.d \
    --with-init-style=debian-sysv \
    --with-pam-confdir=/etc/pam.d \
    --with-tracker-pkgconfig-version=0.16
RUN make
RUN checkinstall \
    --pkgname=netatalk \
    --pkgversion=$netatalk_version \
    --backup=no \
    --deldoc=yes \
    --default \
    --fstrans=no

# Add default user and group
RUN groupadd timemachine
RUN useradd timemachine -m -G timemachine -p 13yb934i7yfb

# Assign permissions
RUN chown timemachine:timemachine /timemachine

# Create the log file
RUN touch /var/log/afpd.log

ADD afp.conf /usr/local/etc/afp.conf
ADD start_services.sh /start_services.sh

EXPOSE 548

VOLUME ["/timemachine"]

CMD [ "/bin/bash", "/start.sh" ]