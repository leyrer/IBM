# NAME

fetch\_files.pl - Download all public files from a IBM Connections instance

# SYNOPSIS

file2Connections.pl [-help|man] -user connections\_username -password connections\_password 
-server connections\_server -workdir dirname

# USAGE

perl fetch\_files.pl -server connections.example.com -user leyrer -password secrethaX0rPass0rd -workdir /home/leyrer/Downloads

# OPTIONS

- __-help__

Print a brief help message and exits.

- __-man__

Prints the manual page and exits.

- __-user__

The name of the connections user to login with.

- __-password__

The IBM Connections password for the user.

- __-server__

The servername (DNS hostname) ot the IBM Connections installation the files should be downloaded from.

- __-workdir__

The direktory, the files shoudl be saved into.

# DESCRIPTION

__fetch\_files__ will download all public files from a Connections server using Connections API and saves those files to the given directory. Exisiting files will be overwriten if they differ in size from the files inside Connections.

A handy tool to download for example all presentations of the IBM Connect 2014 conference.

# NOTABLE INFO

# Versions

This code has been tested with Connection 4.5 and perl 5, version 12, subversion 4 (v5.12.4) built for i686-linux-gnu-thread-multi-64int.

# Installing required libraries on Ubuntu

sudo aptitude install libxml-feedpp-perl

# Licence

Code made available under the Apache 2.0 license. http://www.apache.org/licenses/example-NOTICE.txt

# Authors

Martin Leyrer -- leyrer+connections@gmail.com
