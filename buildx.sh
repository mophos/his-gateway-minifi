docker buildx build --platform linux/amd64 -t mophos/hisgateway-minifi .  --no-cache -o type=docker
docker push mophos/hisgateway-minifi
