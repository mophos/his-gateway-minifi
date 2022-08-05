FROM openjdk:8-jre-alpine

ARG UID=1000
ARG GID=1000
ARG MINIFI_VERSION=1.16.0
ARG MIRROR=https://archive.apache.org/dist

ENV MINIFI_BASE_DIR /opt/minifi
ENV MINIFI_HOME ${MINIFI_BASE_DIR}/minifi-current
ENV MINIFI_BINARY_PATH nifi/${MINIFI_VERSION}/minifi-${MINIFI_VERSION}-bin.tar.gz
ENV MINIFI_BINARY_URL ${MIRROR}/${MINIFI_BINARY_PATH}

# Setup MiNiFi user
RUN addgroup -g $GID minifi || groupmod -n minifi `getent group $GID | cut -d: -f1`
RUN adduser -S -H -G minifi minifi
RUN mkdir -p $MINIFI_BASE_DIR

RUN apk --no-cache add curl

ADD sh/ ${MINIFI_BASE_DIR}/scripts/

# Download, validate, and expand Apache MiNiFi binary.
RUN curl -fSL $MINIFI_BINARY_URL -o $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz \
	&& echo "$(curl $MINIFI_BINARY_URL.sha256) *$MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz" | sha256sum -c - \
	&& tar -xvzf $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz -C $MINIFI_BASE_DIR \
	&& rm $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz \
	&& ln -s $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION $MINIFI_HOME

RUN chown -R -L minifi:minifi $MINIFI_HOME

ADD libs/ ${MINIFI_HOME}/lib/

USER minifi

# Startup MiNiFi
CMD ${MINIFI_BASE_DIR}/scripts/start.sh