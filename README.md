# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it, simply run:

`docker run -h timemachine --name timemachine -d -v /srv/timemachine:/timemachine -t -i -p 548:548 -p 636:636 -p 5353:5353/udp odarriba/timemachine`

Now you have a docker instance running `avahi-daemon` and `netatalk`.

To set up the user to access your backup server do the following:
* Access your docker instance: `docker attach timemachine`
* A shell must appear. Type `passwd timemachine` to change the user password.
* Now you can use the username `timemachine`along with the password you entered.

To save your password for `timemachine` user, you should do this:

* Get your container ID using `docker ps`
* Commit the changes using `docker commit [container_id] odarriba/timemachine`
* Kill the container: `docker kill timemachine`
* Remove the container `docker rm timemachine`
* Run the container again using the command above!

## Auto start the service

This repository contains a script to run the container at boot time **in Ubuntu-based distros**, but it requires that the container have been run manually at least one time.

To install the script, just execute `sudo cp timemachine.conf /etc/init/timemachine.conf`.

* To start the service: `sudo service timemachine start`
* To stop the service: `sudo service timemachine stop`

**Note:** when you stop the service, the container keeps running. Yo must execute `sudo docker stop timemachine`in order to stop the server.

## Modify netatalk's configuration files

If you want to modify the netatalk's configuration file, called `afp.conf`, you can do it cloning this repo, changing it's contents and building the image by your own using `sudo docker build .`

Also, you can change it by accessing the container and modifying it in live, bute remember to save the chhanges like when the password was changed (see above).

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
