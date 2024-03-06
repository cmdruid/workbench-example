# Workbench Example Template

Demonstrates a bare-bones docker workbench, running a database, webserver, and bitcoin node.

## How to Use

Run the install script (for the web demo):

`npm run ct:install`

Run the start script (to start the container):

`npm run ct:start`

Run the login script (to get an interactive shell):

`npm run ct:login`

To exit, type `exit` into the shell.

## Live Demo

When you start the container, it will print out a local IP address for you to use to connect.

Check out the example `getinfo` endpoint by opening this link in your browser (assuming your IP is 172.21.0.2):

`http://172.21.0.2:3300/getinfo`

You should see some JSON data about the bitcoin node running inside the container. Pretty neat!

## Container Filesystem

This section describes the file-system of the container and workbench.

**img**: Root of the filesystem. All files in this path are copied to the root ('/') of the container at boot.

This filesystem is static. Changes made outside the container will require a restart of the container. Changes made inside the container will not persist.

**img/bin**: All binaries that you want to pre-package with your container should go in here.

**img/config**: Keep track of all your config files here.

**img/scripts**: These are the startup scripts that initialize your container.

**img/entrypoint.sh**: The entrypoint script that starts your container after it has been built. Mainly loops through the contents of `img/scripts`.

**profile**: This script is called by the `/root/.bashrc` script on login. Useful for setting up your working environment when using a shell.

**src**: This is where your source code should exist. Files in this path are mounted to the `/root/src` path inside the container.

This file-system is "hot" and mounted as read+write. Any changes made to files outside the container are reflected immediately.

> Note: Files created inside the container will have improper permissions set (to the container user), so you may have to use `chmod` on some occasions to switch permissions back to the host machine.

> There's are better ways to handle permissions when creating files on a mounted volume inside the container, but they are not implemented here in the demo.

**Dockerfile**: The main dockerfile that prepares your container environment. This file should install and configure your desired packages and libraries, and setup your environment variables.

**start.sh**: A light wrapper around the docker API. Used to clear existing containers, then spawn a new container.

## Example Scripts

I have included some example scripts in the `package.json` for launching the container in a node environment.

## Questions / Issues

Feel free to submit an issue if you have a question, or run into a bug. :-)
