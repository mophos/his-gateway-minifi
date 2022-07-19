#!/bin/sh -e

# Continuously provide logs so that 'docker logs' can    produce them
tail -F "/opt/minifi/logs/minifi-app.log" &
"/opt/minifi/bin/minifi.sh" run &
minifi_pid="$!"

trap "echo Received trapped signal, beginning shutdown...;" KILL TERM HUP INT EXIT;

echo MiNiFi running with PID ${minifi_pid}.
wait ${minifi_pid}