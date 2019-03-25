FROM ubuntu:18.04

WORKDIR /root/

RUN apt-get update && \
    apt-get install -y \
        curl \
        git && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get -y install nodejs && \
    git clone https://bitbucket.org/nctu_5g/free5gc.git && \
    cd free5gc/webui && \
    npm install && \
    grep -r "mongodb://localhost" | awk -F : '{print $1}' | xargs -i sed -i 's/localhost/mongodb-svc/g' {}

WORKDIR /root/free5gc/webui

CMD npm run dev

EXPOSE 3000
