# Automated Ace No Medical

### How to run
This project use a docker-compose.override.yml file to setup steam and git credentials (check docker-compose.yml file).

- `make db` to build docker image
- `make run` to run the python script

This is intented to run as a docker image running with a volume.

### What does it do ?
This retrieve latest arma 3 ace version, zip it and verify checksum to trigger or not a commit on the vindicta team repository that will build and publish it.

### Where does this run
For now this run every 6 hours on a private server.
