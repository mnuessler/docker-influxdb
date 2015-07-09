#!/bin/bash

exec /opt/influxdb/influxd \
     -config /etc/influxdb.conf \
     -pidfile /var/run/influxdb/influxdb.pid
