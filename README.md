# InfluxDB Docker Image

## About

A docker image to run InfluxDB inside a docker container. InfluxDB is
a time series, metrics, and analytics database. Please refer to the
[InfluxDB documentation][1] for details.

## How to use this image

### Start an InfluxDB instance

To start a container using the default configuration:

```
docker run -d --name influxdb mnuessler/influxdb
```

You may want to mount a directory from the host into the container, so
that the InfluxDB data persists between container restarts:

```
docker run -d --name influxdb \
    -v /your/host/directory:/var/lib/influxdb \
    mnuessler/influxdb
```

Please note that the data directory on the host must be writable by
the user running the InfluxDB server inside the container:

* User: `influxdb` (uid 999)
* Group: `influxdb` (gid 999)

On your host the uid/gid might map to a different user name.

### Configuration

When started without configuration parameters, a default configuration
is used. For every configuration parameter, the default value can be
overridden using an environment variable, so it is possible to do all
configuration upon container start without touching the configuration
file.

For example, to enable the collectd input listening on port 25827 with
collectd metrics being written to a dabase named "collectd", the
container could be started like so:

```
docker run -d --name influxdb \
    -v /your/host/directory:/var/lib/influxdb
    -e INF_COLLECTD_ENABLED="true"
    -e INF_COLLECTD_BIND_ADDRESS=":25827"
    -e INF_COLLECTD_DATABASE="collectd"
    mnuessler/influxdb
```

### Build the image

```
docker build .
```

[1]: https://influxdb.com/docs/v0.9/introduction/overview.html
