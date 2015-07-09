FROM ubuntu:trusty
MAINTAINER Matthias Nüßler <m.nuessler@web.de>

ENV DEBIAN_FRONTEND noninteractive

ENV INFLUXDB_VERSION 0.9.1

RUN apt-get update && apt-get install -y wget
RUN wget https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb -O /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN dpkg -i /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb && rm /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb

RUN mkdir -p /var/run/influxdb && chown -R influxdb /var/run/influxdb

VOLUME /var/lib/influxdb

# Expose ports for admin server, HTTP API, meta/raft, UDP input, Graphite input, collectd input
EXPOSE 8083 8086 8088 4444 2003 25827

COPY docker-entrypoint.sh /

USER influxdb

ENTRYPOINT ["/docker-entrypoint.sh"]
