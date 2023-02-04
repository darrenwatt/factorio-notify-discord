#!/bin/sh
# tail docker factorio logs and post to discord.sh when something interesting happens
# set -x

echo "Started ..."

SENT=$(tail -n 10 "${SYSLOG_PATH}" | grep "${CONTAINER_NAME}" | egrep '(CHAT|JOIN|LEAVE)'| tail -n 1 |  cut -d ' ' -f10-)

while :
do

        LATEST=$(tail -n 10 "${SYSLOG_PATH}" | grep "${CONTAINER_NAME}" | egrep '(CHAT|JOIN|LEAVE)'| tail -n 1 |  cut -d ' ' -f10-)
        if  [ "$LATEST" != "$SENT" ] && [ -n "$LATEST" ] ; then
                echo "${LATEST}"
		$(bash /usr/local/bin/discord.sh --webhook-url="${DISCORD_WEBHOOK}" --text "${LATEST}")
                SENT=${LATEST}
        fi

        sleep 5
done

