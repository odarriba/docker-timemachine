# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it configure your, simply run:

`docker run -h timemachine --name timemachine -d -v /srv/timemachine:/timemachine -t -i -p 548:548 -p 636:636 -p 5353:5353/udp b4667b4c643b`

Now you have a docker instance running `avahi-daemon` and `netatalk`.

To set up the user to access your backup server do the following:
* Access your docker instance: `docker attach timemachine`
* A shell must appear. Type `passwd timemachine` to change the user password.
* Now you can use the username `timemachine`along with the password you entered.

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
