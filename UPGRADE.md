# Upgrade guide: from AFP to SMB

## Why you should switch to the SMB version?

Because of **performance** and **stability**. Apple has deprecated AFP and they
only support Samba now as the network protocol for Time Machine.

AFP still works, but it is not maintained and it will probably stop working in
future versions of OSX.

Also, we could see amazing performance improvements in some scenarios (like
using Wi-Fi conections for backup).

## Will I lose my old backups?

**No.**

The disk format is still the same, so only the transfer protocol will change.
Time Machine will recognise the old backup and will continue using it.

## Migration isntructions

1. First of all, check that your backups are inside your host machine using a
  volume.

    That means, check that you can find your backup folder in your disk and that
    there are contents inside. If you followed the instructions of the README, the
    data should be there.

2. Stop all Time Machine process in your Macs. To do that, enter on
  `Preferences > Time Machine` and check that there is no backup in progress.

3. Stop current timemachine container and remove it:
    ```
    $ docker stop timemachine
    $ docker rm timemachine
    ```

4. Remove local image:
    ```
    $ docker rmi odarriba/timemachine
    ```

5. Follow current version instructions to start the new container. Check that:
    - you use the same data directory as before
    - you create the same users as before (with same UID and GID if you specified them)

    **Note** The ENV vars have changed, and now all `AFP_` are `SMB_`. if you use
    them in a docker compose file, you should update them.

6. in all your macs, connect again to the server:
    - Connect to your server as explained in the README, using `smb://` instead of
      `afp://`.
    - Go to `Preferences > Time Machine` and click on `Select disk`.
    - Select your new server
    - Time Machine will ask to use the previous backup (if you keeped it) and will
      ask for it's password if it was encrypted.
