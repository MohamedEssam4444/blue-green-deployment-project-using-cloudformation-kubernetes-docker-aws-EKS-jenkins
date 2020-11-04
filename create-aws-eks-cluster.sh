#!/usr/bin/env bash
#step1 create aws eks cluster
eksctl create cluster \
  --name jenkinstest1 \
  --region us-east-2 \
  --version 1.17 \
  --node-type t2.micro \
  --nodes 3 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed

