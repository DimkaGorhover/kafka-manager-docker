FROM openjdk:8-alpine as builder

LABEL maintainer="Clement Laforet <sheepkiller@cultdeadsheep.org>"

ADD ./home/ /root/

ARG KM_VERSION=1.3.1.8

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN apk add --update bash git wget unzip && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd kafka-manager && \
    git checkout ${KM_VERSION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip -q -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh && \
    mv /kafka-manager-${KM_VERSION} /km && \
    #rm -rf /tmp/* $HOME/.sbt $HOME/.ivy2 && \
    echo "${KM_VERSION}" > /km/VERSION

###############################################################################
FROM openjdk:8-jre-alpine

ENV KM_CONFIGFILE="conf/application.conf"

RUN apk add --update bash

COPY --from=builder /km/ /km/

WORKDIR /km
ENV KM_HOME=/km

EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
