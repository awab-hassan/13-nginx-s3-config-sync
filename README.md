# NGINX Config Loader (from S3)

A one-shot bash script that **pulls the authoritative `nginx.conf` from an S3 bucket**, drops it into `/etc/nginx/nginx.conf`, and reloads NGINX in place. Used at production as the bootstrap hook on EC2 instances so that a rolling config change is as simple as `aws s3 cp` → SSM run command, with no config baked into the AMI.

## Highlights

- **Single source of truth** — the live NGINX config lives in `s3://<bucket>/nginx-configs/nginx.conf`; every instance pulls the same file.
- **In-place reload** — `nginx -s reload` applies the change with zero dropped connections; no restart needed.
- **Pairs well with SSM Run Command / EventBridge** — trigger this script on config change via an S3 → EventBridge → SSM chain.

## Tech stack

- **Shell:** Bash
- **Dependencies:** AWS CLI (`aws s3 cp`), NGINX

## Repository layout

```
NGINX-S3/
├── README.md
├── .gitignore
└── nginx.sh
```

## How it works

1. `aws s3 cp s3://$S3_BUCKET/$CONFIG_PATH /etc/nginx/nginx.conf` — overwrite the local config with the canonical version from S3.
2. `sudo nginx -s reload` — signal NGINX to re-read config without dropping connections.

## Prerequisites

- NGINX installed and running on the host
- AWS CLI configured (instance profile with `s3:GetObject` on the bucket is ideal)
- The S3 bucket holds a valid `nginx.conf` under the configured path

## Deployment

Edit the script to set your bucket and path, then:

```bash
sudo bash nginx.sh
```

Or hook it to SSM Run Command for fleet-wide updates:

```bash
aws ssm send-command \
  --document-name AWS-RunShellScript \
  --targets "Key=tag:App,Values=fansocial-web" \
  --parameters 'commands=["sudo bash /opt/XXX/nginx.sh"]'
```

## Notes

- Validate the config before reloading in production: `nginx -t && nginx -s reload`.
- Add a safety check that the downloaded file is non-empty before overwriting `/etc/nginx/nginx.conf`.
- Demonstrates: GitOps-lite for NGINX configuration via S3, decoupling config from the AMI.
