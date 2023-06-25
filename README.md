# pgModeler Builder [![Docker Pulls](https://img.shields.io/docker/pulls/bqtran/pgmodeler-builder.svg?maxAge=2592000)](https://hub.docker.com/r/bqtran/pgmodeler-builder)

A [Docker](https://www.docker.com) container that allows you to build [pgModeler](https://pgmodeler.io/) with one
simple command.

# Features

This container currently produces binaries for Windows x86_64 only. This script is originally from (https://hub.docker.com/r/handcraftedbits/pgmodeler-builder) but updated for v1.0+, which now depends on QT 6.

# Usage

Simply modify the contents of docker-compose.yml to suit your build needs (build version, output volume), and run it. It will take a minimum of 2.5 hrs to build, so go watch a movie or read a book...

Once it is done, copy the contents of the output directory to the destination folder of your choice and simply run the `pgmodeler.exe` executable.  That's it!

# Notes
This compile takes a long time because the mxe cross-compiler has not released precompiled binaries since Jan 2021 (https://pkg.mxe.cc/repos/apt/dists/), so we have to build mxe & qt6 ourselves before building pgmodeler itself. Once mxe binaries are released, I'll look into updating the script, which should decrease compile times immensely.