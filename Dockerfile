FROM centos:centos7
LABEL vendor="Apereo"
LABEL name="CAS Testing Container"
LABEL license="Apache 2.0"
LABEL maintainer="UC Berkeley"

RUN yum -y install \
      git \
      java-1.8.0-openjdk-headless \
      tar \
      unzip \
      wget \
      which \
    && yum -y clean all

WORKDIR /

RUN git clone --depth 1 --single-branch https://github.com/apereo/cas-overlay-template.git cas-overlay \
    && mkdir -p /etc/cas/config /etc/cas/services /cas-overlay/bin \
    && cp -f /cas-overlay/etc/cas/config/*.* /etc/cas/config

COPY thekeystore /etc/cas/

RUN useradd castest \
    && chmod -R 750 /cas-overlay/bin \
    && chmod 750 /cas-overlay/mvnw /cas-overlay/build.sh \
    && chown -R castest:castest /etc/cas /cas-overlay

USER castest
EXPOSE 8080 8443
VOLUME /etc/cas

WORKDIR /cas-overlay
RUN ./mvnw clean package -T 10

CMD java -jar /cas-overlay/target/cas.war
