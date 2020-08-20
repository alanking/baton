#! /bin/bash

cd /baton
ls -lR /baton

autoreconf -i

#./configure --with-irods=/usr/lib/irods
CPPFLAGS="-I/usr/include/irods" LDFLAGS="-L/usr/lib/irods" ./configure

#make
make CPPFLAGS="-I/usr/include/irods -Wno-error=deprecated-declarations" LDFLAGS="-L/usr/lib/irods"

cp -r /baton /irods_packages

