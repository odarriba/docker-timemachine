# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it, simply run:

`sudo docker run -h timemachine --name timemachine -e AFP_LOGIN=<YOUR_USER> -e AFP_PASSWORD=<YOUR_PASS> -e AFP_NAME=<TIME_MACHINE_NAME> -e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB> -d -v /route/to/your/timemachine:/timemachine -t -i -p 548:548 -p 636:636 odarriba/timemachine`

If you don't want to specify the maximum volume size (and use all the space available), you can omit the `-e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB>` variable.

Now you have a docker instance running `avahi-daemon` and `netatalk`.

## Auto-discovering

Avahi daemon is commonly used to help your computers to find the services provided by a server.

Avahi isn't built into this Docker image because, due to Docker's networking limitations, Avahi can't spread it's messages to announce the services.

If you want to enable this feature, you can install Avahi daemon in your host following this steps (Ubuntu version):

* Install `avahi-daemons`: run `sudo apt-get install avahi-daemon avahi-utils`
* Copy the file from `avahi/nsswitch.conf` to `/etc/nsswitch.conf`
* Copy the service description file from `avahi/afpd.service` to `/etc/avahi/services/afpd.service`
* Restart Avahi's daemon: `sudo /etc/init.d/avahi-daemon restart`

*But why you need to install this on your host and not in the container?* Because if you don't do it this way, the discovery message won't be able to reach your computers.

## Auto start the service

This repository contains a script to run the container at boot time **in Ubuntu-based distros**, but it requires that the container have been run manually at least one time.

To install the script, just execute `sudo cp timemachine.conf /etc/init/timemachine.conf`.

* To start the service: `sudo service timemachine start`
* To stop the service: `sudo service timemachine stop`

**Note:** when you stop the service, the container keeps running. Yo must execute `sudo docker stop timemachine`in order to stop the server.

## Modify netatalk's configuration files

If you want to modify the netatalk's configuration file, called `afp.conf`, you can do it cloning this repo, changing the contents in `start_services.sh` script and the re-build the image with `sudo docker build .`.

Also, you can change it by accessing the container and modifying it in live, but remember to save the changes like when the password was changed (see above).

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
