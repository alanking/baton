FROM ubuntu:18.04

# install pre-requisite packages
RUN apt update && \
    DEBIAN_FRONTEND=non-interactive apt install -y wget sudo curl lsb-release autoconf libtool pkg-config libjansson-dev git python3-sphinx

# install iRODS packages
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | sudo apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/renci-irods.list && \
    sudo apt-get update && \
    apt install -y irods-dev irods-runtime

RUN cpan JSON && cpan List::AllUtils

# build baton
RUN git clone https://github.com/wtsi-npg/baton /baton && \
    cd /baton && autoreconf -i && \
    CPPFLAGS="-I/usr/include/irods" LDFLAGS="-L/usr/lib/irods" ./configure && \
    make CPPFLAGS="-I/usr/include/irods -Wno-error=deprecated-declarations" LDFLAGS="-L/usr/lib/irods"

# cleanup
RUN apt clean

ENTRYPOINT ["/baton/src/baton-do"]
CMD []
