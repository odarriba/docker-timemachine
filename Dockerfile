FROM ubuntu:14.04
MAINTAINER Óscar de Arriba <odarriba@gmail.com>

##################
##   BUILDING   ##
##################

# Prerequisites
RUN apt-get --quiet --yes update
ENV DEBIAN_FRONTEND noninteractive
RUN ln -s -f /bin/true /usr/bin/chfn

# Versions to use
ENV libevent_version 2.0.22-stable
ENV netatalk_version 3.1.7
ENV dev_libraries libavahi-client-dev libcrack2-dev libwrap0-dev autotools-dev libdb-dev libacl1-dev libdb5.3-dev libgcrypt11-dev libtdb-dev libkrb5-dev

# Install prerequisites:
RUN apt-get --quiet --yes install build-essential wget pkg-config checkinstall git avahi-daemon avahi-utils automake libtool db-util db5.3-util libgcrypt11 ${dev_libraries}

# Compiling libevent
WORKDIR /usr/local/src
RUN wget https://sourceforge.net/projects/levent/files/libevent/libevent-2.0/libevent-${libevent_version}.tar.gz \
	&& tar xfv libevent-${libevent_version}.tar.gz \
	&& cd libevent-${libevent_version} \
	&& ./configure \
	&& make \
	&& checkinstall \
		--pkgname=libevent-${libevent_version} \
		--pkgversion=${libevent_version} \
		--backup=no \
		--deldoc=yes \
		--default --fstrans=no

# Compiling netatalk
WORKDIR /usr/local/src
RUN wget http://ufpr.dl.sourceforge.net/project/netatalk/netatalk/${netatalk_version}/netatalk-${netatalk_version}.tar.gz \
	&& tar xfv netatalk-${netatalk_version}.tar.gz \
	&& cd netatalk-${netatalk_version} \
	&& ./configure \
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
		--with-tracker-pkgconfig-version=0.16 \
	&& make \
	&& checkinstall \
		--pkgname=netatalk \
		--pkgversion=$netatalk_version \
		--backup=no \
		--deldoc=yes \
		--default \
		--fstrans=no

# Add default user and group
RUN groupadd timemachine \
	&& useradd timemachine -m -g timemachine -p 13yb934i7yfb \
	&& mkdir -p /timemachine \
	&& mkdir /var/run/dbus \
	&& chown timemachine:timemachine /timemachine

# Change the hostname
RUN hostname timemachine

# Create the log file
RUN touch /var/log/afpd.log

ADD afp.conf /usr/local/etc/afp.conf
ADD start_services.sh /start_services.sh

EXPOSE 548 636 5353/udp

VOLUME ["/timemachine"]

CMD [ "/bin/bash", "/start_services.sh" ]