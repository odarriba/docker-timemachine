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
RUN apt-get --quiet --yes install build-essential nano htop wget pkg-config checkinstall git avahi-daemon avahi-utils automake libtool db-util db5.3-util libgcrypt11 ${dev_libraries}

# Compiling netatalk
WORKDIR /usr/local/src
RUN wget http://prdownloads.sourceforge.net/netatalk/netatalk-${netatalk_version}.tar.gz \
	&& tar xvf netatalk-${netatalk_version}.tar.gz \
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
	&& make \
	&& checkinstall \
		--pkgname=netatalk \
		--pkgversion=$netatalk_version \
		--backup=no \
		--deldoc=yes \
		--default \
		--fstrans=no

# Add default user and group
RUN  mkdir -p /timemachine \
	&& mkdir /var/run/dbus

# Create the log file
RUN touch /var/log/afpd.log

ADD config/nsswitch.conf /etc/nsswitch.conf
ADD start_services.sh /start_services.sh

EXPOSE 548 636

VOLUME ["/timemachine"]

CMD [ "/bin/bash", "/start_services.sh" ]