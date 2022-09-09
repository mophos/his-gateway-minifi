FROM apache/nifi-minifi

COPY bootstrap.conf ${MINIFI_HOME}/conf/bootstrap.conf
ADD libs/ ${MINIFI_HOME}/libs/
ENV TZ="Asia/Bangkok"
ADD config.yml ${MINIFI_HOME}/config/config.yml
