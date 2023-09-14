#!/bin/bash

#create new group and user
 groupadd prometheus
 useradd prometheus -m -g prometheus

#download prometheus and node_exporter
  cd /home/prometheus
  wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz
  wget https://github.com/prometheus/prometheus/releases/download/v2.46.0/prometheus-2.46.0.linux-amd64.tar.gz
  git clone https://github.com/Minty-Mario/grafana_prometheusConfig.git

# extract both tarballs and remove them
  tar -xf node*
  sleep 2 &
  wait
  tar -xf prometheus*
  sleep 2 &
  wait
  rm -rf *.tar.gz

#give the right permissions
  chmod 775 prometheus-2.46.0.linux-amd64
  chmod 775 node_exporter-1.6.1.linux-amd64
  chown prometheus:prometheus prometheus-2.46.0.linux-amd64
  chown prometheus:prometheus node_exporter-1.6.1.linux-amd64

#backup the prometheus yml file
  cd prometheus-2.46.0.linux-amd64
  mv prometheus.yml prometheusyml.bak

#place the files in the right place
  cd ../grafana_prometheusConfig
  mv node_exporter.service /etc/systemd/system/
  mv prometheus.service /etc/systemd/system/
  mv prometheus.yml ../prometheus-2.46.0.linux-amd64

#start both services
 systemctl daemon-reload
 systemctl start prometheus.service
 systemctl start node_exporter.service
