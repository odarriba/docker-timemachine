# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Installation

To download the docker container and execute it, simply run:

```
$ docker run -h timemachine --name timemachine --restart=unless-stopped -d -v /route/to/your/timemachine:/timemachine -it -p 548:548 -p 636:636 odarriba/timemachine
```

To add users, just run this command:

```
$ docker exec timemachine add-account USERNAME PASSWORD VOL_NAME MOUNT_POINT [VOL_SIZE_MB]
```

But take care that:
* `VOL_NAME` will be the name of the volume shown on your OSX as the network drive
* `MOUNT_POINT` should be an absolute path, preferably a sub-path of `/timemachine` (e.g., `/timemachine/backup`), so it will be stored in the according sub-path of your external volume.
* `VOL_SIZE_MB` is an optional parameter. It indicates the max volume size for that user.

Now you have a docker instance running `netatalk`.

## Auto-discovering

Avahi daemon is commonly used to help your computers to find the services provided by a server.

Avahi isn't built into this Docker image because, due to Docker's networking limitations, Avahi can't spread it's messages to announce the services.

**If you want to enable this feature, you can install Avahi daemon in your host** following this steps (Ubuntu version):

* Install `avahi-daemon`: run `sudo apt-get install avahi-daemon avahi-utils`
* Copy the file from `avahi/nsswitch.conf` to `/etc/nsswitch.conf`
* Copy the service description file from `avahi/afpd.service` to `/etc/avahi/services/afpd.service`
* Restart Avahi's daemon: `sudo /etc/init.d/avahi-daemon restart`

**But why you need to install this on your host and not in the container?** Because if you don't do it this way, the discovery message won't be able to reach your computers.

## Auto start the service

As the image has been started using the `--restart=always` flag, it will start when the computers boots up.

## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
* Josef Friedrich ([@Josef-Friedrich](https://github.com/Josef-Friedrich))
