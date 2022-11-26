#!/bin/bash

mvn package && cd terraform && terraform apply --auto-approve