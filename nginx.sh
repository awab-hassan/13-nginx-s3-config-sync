#!/bin/bash

# Define the S3 bucket and path
S3_BUCKET="your-s3-bucket-name"
CONFIG_PATH="nginx-configs/nginx.conf"

# Fetch NGINX configuration from S3
aws s3 cp s3://$S3_BUCKET/$CONFIG_PATH /etc/nginx/nginx.conf

# Reload NGINX to apply configuration
sudo nginx -s reload
