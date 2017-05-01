#!/usr/bin/python

"""Basic environment for my personal cloud server."""

import subprocess

def install_docker():
    """Install docker into a server."""

    cmd = "apt-get install apt-transport-https \
                           ca-certificates \
                           curl \
                           software-properties-common"

    retcode = subprocess.call(cmd, shell=True)
    if retcode:
        print "retcode {}".format(retcode)

def __main__():
    install_docker()
