FROM ubuntu:18.04

WORKDIR /root/

RUN apt-get update && \
    apt install mongodb -y && \
    sed -i 's/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/g' /etc/mongodb.conf

CMD /etc/init.d/mongodb start
