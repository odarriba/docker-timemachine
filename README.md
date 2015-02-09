# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it configure your, simply run:

`docker run -h timemachine --name timemachine -d -v /srv/timemachine:/timemachine -t -i -p 548:548 -p 636:636 -p 5353:5353/udp odarriba/timemachine`

Now you have a docker instance running `avahi-daemon` and `netatalk`.

To set up the user to access your backup server do the following:
* Access your docker instance: `docker attach timemachine`
* A shell must appear. Type `passwd timemachine` to change the user password.
* Now you can use the username `timemachine`along with the password you entered.

To save your password for `timemachine` user, you should do a docker commit of the current image and stop/kill and remove the container, and create another using `docker run` with the params above.

## Autostart the service

To start the service when the host starts (the machine running docker, not the container), there is a `timemachine.conf` file that you can copy on `/etc/init/` on Ubuntu-based systems. This allows this container to start on boot time (if the name of the container is `timemachine`).

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
