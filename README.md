# Uptime Kuma Linux Server Health Monitor

A Bash script that monitors system usage stats and alerts if they rise above configurable limits.

Checks disk free space, CPU load average, RAM usage, and ZFS pool health.

## One-line installer

Copy-paste to install the script and push status to Uptime Kuma every 60 seconds.
Then just edit `/opt/uptimekuma.sh` (if installed as root) or `$HOME/.local/bin/uptimekuma.sh` (if installed as user)
to configure the `API_URL` and `PUSH_KEY` and optionally customize alert parameters.

### As root:

```bash
mkdir -p /opt && wget -O /opt/uptimekuma.sh https://source.netsyms.com/Netsyms/uptime-kuma-server-health/raw/branch/main/uptimekuma.sh && chmod +x /opt/uptimekuma.sh && crontab -l | { cat; echo "* * * * * /opt/uptimekuma.sh"; } | crontab -
```

### As user:

```bash
mkdir -p $HOME/.local/bin && wget -O $HOME/.local/bin/uptimekuma.sh https://source.netsyms.com/Netsyms/uptime-kuma-server-health/raw/branch/main/uptimekuma.sh && chmod +x $HOME/.local/bin/uptimekuma.sh && crontab -l | { cat; echo "* * * * * $HOME/.local/bin/uptimekuma.sh"; } | crontab -
```