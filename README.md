# alpine-zookeeper
Docker container image with
- OpenJDK 8-jre-alpine
- Apache Zookeeper 3.6.0
- Image size is 161MB

## Steps
1. Mount /data/zookeeper to the guest host
2. Expose 2181, 2888, 3888 ports to host os

## Build
```
docker build -t ngpsanjaya/alpine-zookeeper:1.0.0 .
```

## Run docker containers
### Run single node
```
docker run --name alpine-zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=1 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d ngpsanjaya/alpine-zookeeper:1.0.0
```

## Run three ensemble cluster
### On host1 172.0.0.1
```
docker run --name alpine-zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=1 -e ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2,172.0.0.3 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d ngpsanjaya/alpine-zookeeper:1.0.0
```

### On host 172.0.0.2
```
docker run --name alpine-zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=2 -e ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2,172.0.0.3 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d ngpsanjaya/alpine-zookeeper:1.0.0
```

### On host 172.0.0.3
```
docker run --name alpine-zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=3 -e ENSEMBLE_HOST_NAMES=172.0.0.1,172.0.0.2,172.0.0.3 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d ngpsanjaya/alpine-zookeeper:1.0.0
```

## Verify
```
telnet 172.17.0.1 2181
telnet 172.17.0.2 2181
telnet 172.17.0.3 2181
```

## Connect to remote zookeeper from local zookeeper installation, with zkCli.sh
```
./bin/zkCli.sh -timeout 3000 -server 172.0.0.1:2181
```
## Release


### Build on build server
```
docker build -t gcr.io/satacs-be-pre-prod/dafabet/centos-zookeeper:1.0.0 .
docker push gcr.io/satacs-be-pre-prod/dafabet/centos-zookeeper:1.0.0
```

### Run on production servers
#### 172.28.6.166
```
mkdir /data/zookeeper
docker pull gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=1 -e ENSEMBLE_HOST_NAMES=172.28.6.166,172.28.6.167,172.28.6.168 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
```

#### 172.28.6.167
```
mkdir /data/zookeeper
docker pull gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=2 -e ENSEMBLE_HOST_NAMES=172.28.6.166,172.28.6.167,172.28.6.168 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
```

#### 172.28.6.168
```
mkdir /data/zookeeper
docker pull gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
docker run --name zookeeper -v /data/zookeeper:/data/zookeeper -e MY_ID=3 -e ENSEMBLE_HOST_NAMES=172.28.6.166,172.28.6.167,172.28.6.168 -p 2181:2181 -p 2888:2888 -p 3888:3888 -d gcr.io/satacs-be-pre-prod/dafabet/alpine-zookeeper:1.0.0
```

### Verify
```
telnet 172.28.6.166 2181
telnet 172.28.6.167 2181
telnet 172.28.6.168 2181
```

#### Allow ports from firewall(CentOS host)
```
firewall-cmd --zone=public --add-port=2181/udp --add-port=2181/tcp --permanent
firewall-cmd --reload
```