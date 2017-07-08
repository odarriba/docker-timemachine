# docker-timemachine
A docker container to compile the lastest version of Netatalk in order to run a Time Machine server.

## Platforms
If you want to use this on an ARM-Device, use this Branch instead: https://github.com/odarriba/docker-timemachine/tree/rpi

## Installation

### Step 1 - Start the Server

To download the docker container and execute it, simply run:

```
$ docker run -h timemachine --name timemachine --restart=unless-stopped -d -v /external_volume:/timemachine -it -p 548:548 -p 636:636 odarriba/timemachine
```

Replace `external_volume` with a local path where you want to store your data.

As the image has been started using the `--restart=always` flag, it will start when the computers boots up.



### Step 2 - Add a User

To add a user, run:

```
$ docker exec timemachine add-account USERNAME PASSWORD MOUNT_POINT [VOL_SIZE_MB]
```

But take care that:
* `MOUNT_POINT` should be an absolute path, preferably a sub-path of `/timemachine` (e.g., `/timemachine/backup`), so it will be stored in the according sub-path of your external volume.
* `VOL_SIZE_MB` is an optional parameter. It indicates the max volume size for that user.

Now you have a docker instance running `netatalk`.


### Step 3 - Enable Auto Discovery

Avahi daemon is commonly used to help your computers to find the services provided by a server.

Avahi isn't built into this Docker image because, due to Docker's networking limitations, Avahi can't spread it's messages to announce the services.

**If you want to enable this feature, you can install Avahi daemon on your host** following these steps (Ubuntu version):

* Install `avahi-daemon`: run `sudo apt-get install avahi-daemon avahi-utils`
* Copy the file from `avahi/nsswitch.conf` to `/etc/nsswitch.conf`
* Copy the service description file from `avahi/afpd.service` to `/etc/avahi/services/afpd.service`
* Restart Avahi's daemon: `sudo /etc/init.d/avahi-daemon restart`


### Step 4 - Configure Your Firewall

Make sure

* your server can receive traffic on port `548` and `636` (e.g., `ufw allow 548`, (`636` respectively)).

* your Mac allows outgoing connections (Little Snitch?)



### Step 5 - Start Using It

To start using it, follow these steps:

* If you use Avahi, open **Finder**, go to **Shared** and connect to your server with your new username and password.

* Alternatively (or if you don't use Avahi) from **Finder** press **CMD-K** and type `afp://your-server` where `your-server` can be your server's name or IP address (e.g., `afp://my-server` or `afp://192.168.0.5`).

* Go to **System Preferences**, and open **Time Machine** settings.

* Open **Add or Remove Backup Disk...**

* Select your new volume.


In the example below, the Docker instance is running on server `central`. For `USERNAME` the account `Backup` along with a `PASSWORD` was created. Once connected, the account `Backup` is available in Time Machine settings:
![alt text](docs/overview.jpg "Getting Started")


## Advanced Usage

### Configure using environment variables

You can configure the container using environment variables (for example, if you use a `docker-compose` environment).

There are these environment variables:

* **AFP_LOGIN**: User name
* **AFP_PASSWORD**: User password
* **AFP_NAME**: Name of the volume
* **AFP_SIZE_LIMIT**: Size in MB of the volume (optional)

Using these variables, the container will create a user at boot time (only one per container).


## FAQ


#### I got Docker running, my firewall is configured, but I still don't find the service in Time Machine.

Make sure you actually mount the server volume (see Step 5) before trying to find it in Time Machine settingss.  

#### I am still having trouble ...

* The idea of using avahi-daemon installed in the bare metal server is to avoid having to execute the container with --net=host, which a potentially insecure flag. But, as the last option to check things out, it should be fine. You just should know what you are enabling.

* A Time Machine network disk is just a disk image in an AFP volume that supports the correct level of encryption. So to be recognised by the TimeMachine daemon, you should mount the unit manually for the first time, configure TimeMachine on your computer, and then the OS will do that for you automatically.



#### Why do I need to install Avahi on your host and not in the container?

Because if you don't do it this way, the discovery message won't be able to reach your computers.



## Contributors

* Óscar de Arriba (odarriba@gmail.com)
* Daniel Iñigo (demil133@gmail.com)
* Josef Friedrich ([@Josef-Friedrich](https://github.com/Josef-Friedrich))
