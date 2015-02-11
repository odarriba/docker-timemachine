# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it, simply run:

`sudo docker run -h timemachine --name timemachine -e AFP_LOGIN=<YOUR_USER> -e AFP_PASSWORD=<YOUR_PASS> -e AFP_NAME=<TIME_MACHINE_NAME> -e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB> -d -v /route/to/your/timemachine:/timemachine -t -i -p 548:548 -p 636:636 odarriba/timemachine`

If you don't want to specify the maximum volume size (and use all the space available), you can omit the `-e AFP_SIZE_LIMIT=<MAX_SIZE_IN_MB>` variable.

Now you have a docker instance running `avahi-daemon` and `netatalk`.

**Note about auto-discovering:** due to network restrictions with Docker, avahi-daemon can't spread it's name in your home's LAN. To avoid this, you can try to manually create the AFP's configuration file in an avahi-daemon instance running in your host operating system. *But it is a untested configuration*.

## Auto start the service

This repository contains a script to run the container at boot time **in Ubuntu-based distros**, but it requires that the container have been run manually at least one time.

To install the script, just execute `sudo cp timemachine.conf /etc/init/timemachine.conf`.

* To start the service: `sudo service timemachine start`
* To stop the service: `sudo service timemachine stop`

**Note:** when you stop the service, the container keeps running. Yo must execute `sudo docker stop timemachine`in order to stop the server.

## Modify netatalk's configuration files

If you want to modify the netatalk's configuration file, called `afp.conf`, you can do it cloning this repo, changing the contentes in `start_services.sh` script and the re-build the image with `sudo docker build .`.

Also, you can change it by accessing the container and modifying it in live, but remember to save the chhanges like when the password was changed (see above).

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
