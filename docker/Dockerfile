FROM ubuntu:18.04

WORKDIR /root/

ENV PATH=$PATH:/usr/local/go/bin

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        libtool \
        gcc \
        pkg-config \
        git \
        flex \
        bison \
        libsctp-dev \
        libgnutls28-dev \
        libgcrypt-dev \
        libssl-dev \
        libidn11-dev \
        libmongoc-dev \
        libbson-dev \
        libyaml-dev \
        build-essential \
        iproute2 \
        ca-certificates \
        netbase \
        net-tools \
        software-properties-common \
        wget \
        unzip \
        iptables && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install g++-7 && \
    apt-get clean && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
                         --slave /usr/bin/g++ g++ /usr/bin/g++-7 && \
    update-alternatives --config gcc && \
    wget https://dl.google.com/go/go1.12.linux-amd64.tar.gz && \
    sha256sum go1.12.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.12.linux-amd64.tar.gz && \
    /bin/bash -c "source ~/.profile" && \
    go get -u -v "github.com/gorilla/mux" && \
    go get -u -v "golang.org/x/net/http2" && \
    go get -u -v "golang.org/x/sys/unix" && \
    git clone https://github.com/tw0927041027/kube5gc && \
    cd kube5gc/docker/ && \
    unzip free5gc.zip && \
    cd free5gc && \
    autoreconf -iv && \
    ./configure --prefix=`pwd`/install && \
    make -j `nproc` && \
    make install && \
    grep -r "mongodb://localhost" | awk -F : '{print $1}' | xargs -i sed -i 's/localhost/mongodb-svc/g' {} && \
    cp /root/kube5gc/docker/setup-uptun.sh setup-uptun.sh
