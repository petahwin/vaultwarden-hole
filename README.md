# Vaultwarden with RPi #

This repo implements a Vaultwarden server on a Raspberry Pi, along with network
plumbing and service automation for bringup.

## Features ##
- Wraps bringup and teardown of the Vaultwarden server instance as a systemd service
- Adds an Nginx proxy configuration to manage mandatory SSL communications
- Provides scripts to
    - Generate self signed certs required for SSL communication
    - Schedule automated backups of encrypted Vaultwarden server data to Google drive

## System Requirements ##
- Docker
- Nginx
- Tested on:
    - HW Platform: Raspberry Pi 4
    - OS: Raspbian Buster

## TODO ##
- [ ] Once Bitwarden/Vaultwarden makes it possible through their API, automate backups of only encrypted vault data (instead of the entire DB)
- [ ] Write up Ansible playbook to automate installation and setup of Docker, Nginx, systemd services, cron jobs
