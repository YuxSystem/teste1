#!/bin/bash

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 797977794545.dkr.ecr.us-east-1.amazonaws.com

docker pull 797977794545.dkr.ecr.us-east-1.amazonaws.com/chatlink:latest

docker stop chatlink-server

docker rm chatlink-server

docker run --name chatlink-server -d -p 8080:8080 --network chatlink-network 797977794545.dkr.ecr.us-east-1.amazonaws.com/chatlink:latest

docker logs chatlink-server -f
