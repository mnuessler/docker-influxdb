FROM debian:jessie
MAINTAINER Matthias Nüßler <m.nuessler@web.de>

ENV INFLUXDB_VERSION 0.9.1
ENV IMAGE_VERSION 2

LABEL Description="InfluxDB time series database server $INFLUXDB_VERSION" \
      InfluxDbVersion=$INFLUXDB_VERSION \
      ImageVersion=$IMAGE_VERSION \
      Version="$INFLUXDB_VERSION_$IMAGE_VERSION"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get clean
ADD https://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb \
    /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb
RUN dpkg -i /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
    rm /tmp/influxdb_${INFLUXDB_VERSION}_amd64.deb
ADD https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64 \
    /usr/local/bin/gosu &&
RUN chmod +x /usr/local/bin/gosu

RUN mkdir -p /var/run/influxdb && chown -R influxdb:influxdb /var/run/influxdb
RUN mkdir -p /var/lib/influxdb && chown -R influxdb:influxdb /var/lib/influxdb

# This is the location where InfluxDB stores all data. Mount a host
# directory here to keep data after container restarts.
VOLUME /var/lib/influxdb

# Expose ports for admin server, HTTP API, meta/raft, UDP input,
# Graphite input, collectd input
EXPOSE 8083 8086 8088 4444 2003 25827

# Needed only if collectd input is enabled
RUN mkdir -p /usr/share/collectd
COPY types.db /usr/share/collectd/

COPY entrypoint.sh /
COPY config.toml /etc/influxdb/

ENTRYPOINT ["/entrypoint.sh"]
