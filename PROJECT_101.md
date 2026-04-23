# PROJECT_101: NGINX-S3

## What is this?
A script that pulls `nginx.conf` from **S3** at instance boot so EC2 hosts always start with the latest config — no AMI rebake needed.

## Why it matters
Changing nginx config without this pattern = SSH to every box + restart. With it = push to S3, instances pick up on reboot (or cron).

## What you did
- Boot script: `aws s3 cp s3://bucket/nginx.conf /etc/nginx/`
- `nginx -t` to validate before reload
- Cron/systemd timer to re-pull periodically

## Interview one-liner
"I decoupled nginx config from the AMI — config lives in S3, boxes pull it on boot and on schedule."

## Key concepts
- **AMI vs. userdata** — bake-once vs. configure-on-boot
- **`nginx -t`** before reload to avoid dropping traffic
- **Instance profile** giving EC2 permission to read the config bucket
