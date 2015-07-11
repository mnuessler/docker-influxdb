FROM debian:jessie
MAINTAINER Matthias Nüßler <m.nuessler@web.de>

ENV INFLUXDB_VERSION 0.9.1
ENV IMAGE_VERSION 1

LABEL Description="Starts an InfluxDB $INFLUXDB_VERSION server" \
      InfluxDbVersion=$INFLUXDB_VERSION \
      ImageVersion=$IMAGE_VERSION \
      Version="$INFLUXDB_VERSION_$IMAGE_VERSION"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y curl
RUN curl -sSL https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb \
    -o /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN dpkg -i /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb && rm /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN curl -sSL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    -o /usr/local/bin/gosu && chmod +x /usr/local/bin/gosu
RUN apt-get clean

RUN mkdir -p /var/run/influxdb && chown -R influxdb:influxdb /var/run/influxdb
RUN mkdir -p /var/lib/influxdb && chown -R influxdb:influxdb /var/lib/influxdb

VOLUME /var/lib/influxdb

# Expose ports for admin server, HTTP API, meta/raft, UDP input,
# Graphite input, collectd input
EXPOSE 8083 8086 8088 4444 2003 25827

COPY docker-entrypoint.sh /
COPY config.toml /etc/influxdb/config.toml

ENTRYPOINT ["/docker-entrypoint.sh"]
