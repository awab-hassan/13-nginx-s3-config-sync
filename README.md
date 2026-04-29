# NGINX S3 Config Sync Setup

A Bash script that pulls `nginx.conf` from an S3 bucket and reloads NGINX in place — no restart, zero dropped connections. Designed as a bootstrap/update hook on EC2 instances so config changes require no AMI rebuild; just update the file in S3 and trigger the script.

## How It Works

1. Downloads the canonical `nginx.conf` from `s3://<bucket>/nginx-configs/nginx.conf` to `/etc/nginx/nginx.conf`
2. Runs `nginx -s reload` to apply the new config without dropping active connections

## Stack

Bash · AWS CLI · NGINX

## Prerequisites

- NGINX installed and running
- AWS CLI configured — an instance profile with `s3:GetObject` on the target bucket is the recommended approach
- A valid `nginx.conf` present at the configured S3 path

## Usage

Set your bucket and path in the script, then:

```bash
sudo bash nginx.sh
```

For fleet-wide rollout via SSM Run Command:

```bash
aws ssm send-command \
  --document-name AWS-RunShellScript \
  --targets "Key=tag:App,Values=myapp-web" \
  --parameters 'commands=["sudo bash /opt/nginx-s3-config-sync/nginx.sh"]'
```

Pairs naturally with an S3 → EventBridge → SSM chain for automated config propagation.

## Repository Layout

```
nginx-s3-config-sync/
├── nginx.sh
├── .gitignore
└── README.md
```
