# Factorio Notify Discord
This is an image which tails your Factorio container log output for CHAT/JOIN/LEAVE messages and posts them to Discord.
If you want, other events may be filtered also, just update and rebuild the image.

It relies on Factorio logging to syslog, which you can also run as a container (see below, docker-compose)

### Building the image
```
docker build -t darrenwatt/factorio-notify-discord:latest .
```

### REQUIRED env vars for container
```
CONTAINER_NAME="factorio"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/..."
SYSLOG_PATH="/logs/messages"
```

### Running the container standalone
```
docker run --name factorio-notify-discord -e CONTAINER_NAME="factorio" -e DISCORD_WEBHOOK="https://discord.com/api/webhooks/..." -e SYSLOG_PATH="/logs/messages" -v /media/syslog-ng/logs:/logs darrenwatt/docker-notify-discord:latest .
```

### docker-compose
```
  factorio-notify-discord:
    image: darrenwatt/factorio-notify-discord:latest
    container_name: factorio-notify-discord
    environment:
      - CONTAINER_NAME=factorio
      - DISCORD_WEBHOOK=https://discord.com/api/webhooks/...
      - SYSLOG_PATH=/logs/messages
    volumes:
      - /mnt/syslog-ng/logs:/logs
    restart: unless-stopped
```

### docker-compose (factorio)

You will also need this set in factorio container to output to your syslog container, I've tested with balabit/syslog-ng:latest

To get syslog working I had to manually chown the log directory, you may need to do the same:
chown -R uid:gid ./log

```
  factorio:
    logging:
      driver: syslog
      options:
        syslog-address: "udp://<syslog host or ip address>:514"
        tag: "{{.Name}}/{{.ID}}"
```
