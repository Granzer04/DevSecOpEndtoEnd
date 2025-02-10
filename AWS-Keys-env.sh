#!/bin/bash

# Append AWS credentials to /etc/environment
echo 'export AWS_ACCESS_KEY_ID=<PUT-KEY-HERE>' | sudo tee -a /etc/environment
echo 'export AWS_SECRET_ACCESS_KEY=<PUT-KEY-HERE>' | sudo tee -a /etc/environment
echo 'export AWS_DEFAULT_REGION=us-east-1' | sudo tee -a /etc/environment

echo "AWS credentials added to /etc/environment. Restart or re-login to apply changes."