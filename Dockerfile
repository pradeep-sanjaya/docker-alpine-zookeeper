FROM openjdk:8-jre-alpine

COPY entrypoint.sh /entrypoint.sh

ENV ZOOKEEPER_VERSION="3.6.1"

RUN apk --update add --no-cache python curl tar bash && \
    curl -fL https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz | tar xzf - -C /opt && \
    mv /opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin /opt/zookeeper && \
    rm -f apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && \
    chmod +x /entrypoint.sh

VOLUME /data/zookeeper

WORKDIR /opt/zookeeper/bin

# client port=2181, connect to leader=2888, leader election=3888
EXPOSE 2181 2888 3888

ENTRYPOINT ["/entrypoint.sh"]
CMD ["./zkServer.sh", "start-foreground"]