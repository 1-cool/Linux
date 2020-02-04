#!/bin/bash
port=$(grep \"port /etc/v2ray/config.json | tr -cd "[0-9]")
lsof -i -n -P | egrep ':${port}.+ESTABLISHED'
