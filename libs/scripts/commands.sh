#!/bin/sh
/app_generate/generate > /dev/null &
/opt/minifi/scripts/start.sh > /dev/null &
/app/server