# kube5gc

> on Kubernetes

### Install OVS on node host and Add interface to OVS
```sh
apt install openvswitch-switch
ovs-vsctl add-br br0
ovs-vsctl add-port br0 enp5s2
```

### Create Daemonset
```sh
kubectl create -f kube5gc/deploy/namespace
```

### Create Namespace
```sh
kubectl create namespace free5gc
```

### Create mongodb
```sh
cd kube5gc/deploy/mongodb
kubectl create -f .
```

### Create free5gc
```sh
cd kube5gc/deploy/
kubectl apply -f .
```

### Create webui
```sh
cd kube5gc/deploy/webui
kubectl create -f .
```

### Check Pod
```sh
watch kubectl get pod -n free5gc
```

> on Docker

### Install Docker
```sh
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
sudo apt-get update
sudo apt-get install docker-ce
```

### Create Docker Network
```sh
docker network create --subnet=192.188.2.0/24 free5gc
```

### Add interface to bridge
```sh
brctl addif br-647853228fe2 enp3s2
```

### Docker run and Assign static IP to Docker container
```sh
docker run -ti -d --privileged --net free5gc --ip 192.188.2.2 --name amf tw0927041027/free5gc-base bash
docker run -ti -d --privileged --net free5gc --ip 192.188.2.3 --name smf tw0927041027/free5gc-base bash
docker run -ti -d --privileged --net free5gc --ip 192.188.2.4 --name hss tw0927041027/free5gc-base bash
docker run -ti -d --privileged --net free5gc --ip 192.188.2.5 --name pcrf tw0927041027/free5gc-base bash
docker run -ti -d --privileged --net free5gc --ip 192.188.2.6 --name upf tw0927041027/free5gc-base bash
docker run -ti -d --net free5gc --ip 192.188.2.100 --name mongodb tw0927041027/free5gc-mongodb bash
docker run -ti -d -p 3000:3000 --net free5gc --ip 192.188.2.101 --name webui tw0927041027/free5gc-webui bash
```

### Editing the configuration files
```sh
docker cp ./free5gc.conf amf:/root/free5gc/install/etc/free5gc/free5gc.conf
docker cp ./free5gc.conf smf:/root/free5gc/install/etc/free5gc/free5gc.conf
docker cp ./free5gc.conf hss:/root/free5gc/install/etc/free5gc/free5gc.conf
docker cp ./free5gc.conf pcrf:/root/free5gc/install/etc/free5gc/free5gc.conf
docker cp ./free5gc.conf upf:/root/free5gc/install/etc/free5gc/free5gc.conf
docker cp ./amf.conf amf:/root/free5gc/install/etc/free5gc/freeDiameter/amf.conf
docker cp ./smf.conf smf:/root/free5gc/install/etc/free5gc/freeDiameter/smf.conf
docker cp ./hss.conf hss:/root/free5gc/install/etc/free5gc/freeDiameter/hss.conf
docker cp ./pcrf.conf pcrf:/root/free5gc/install/etc/free5gc/freeDiameter/pcrf.conf
```

### Running and testing
```sh
docker exec -ti mongodb bash
/etc/init.d/mongodb start
docker exec -ti amf bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && /root/free5gc/install/bin/free5gc-amfd &
docker exec -ti smf bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && /root/free5gc/install/bin/free5gc-smfd &
docker exec -ti hss bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && /root/free5gc/install/bin/nextepc-hssd &
docker exec -ti pcrf bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && /root/free5gc/install/bin/nextepc-pcrfd &
docker exec -ti upf bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && /root/free5gc/install/bin/free5gc-upfd &
docker exec -ti webui bash
echo 192.188.2.100 mongodb-svc >> /etc/hosts && cd /root/free5gc/webui && npm run dev &
```
