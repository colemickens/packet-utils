#!/usr/bin/env bash

function packet_device_list() {
  curl \
    -H 'APITOKEN: ${PACKET_API_TOKEN}'
    http://packet.net/devices
}

function packet_device_create() {
  curl \
    -H 'APITOKEN: ${PACKET_API_TOKEN}'
    http://packet.net/devices
}

