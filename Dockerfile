FROM openjdk:8-jre-alpine
LABEL Author="Satit Rianpit"

WORKDIR /opt/minifi

ARG UID=1000
ARG GID=1000
 
ENV LANG=C.UTF-8

COPY --from=mophos/minifi-api-go /app/ /app/
COPY --from=mophos/minifi-generate-config /app_generate/ /app_generate/

RUN addgroup -g $GID minifi || groupmod -n minifi `getent group $GID | cut -d: -f1`
RUN adduser -S -H -G minifi minifi

ADD libs/minifi /opt/minifi

ADD libs/scripts /opt/minifi/scripts

RUN mkdir /opt/minifi/logs && touch /opt/minifi/logs/minifi-app.log

RUN chown -R -L minifi:minifi /opt/minifi

USER minifi

EXPOSE 3000

# Startup MiNiFi & Go api
ENTRYPOINT ["./scripts/commands.sh"]