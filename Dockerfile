FROM nodered/node-red:latest

USER root
RUN apk add --no-cache sqlite
USER node-red

COPY db/init.sql /opt/lyvia/init.sql
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
USER root
RUN sed -i 's/\r$//' /docker-entrypoint.sh \
  && chmod +x /docker-entrypoint.sh
USER node-red

RUN npm install --unsafe-perm --no-update-notifier --no-fund --omit=dev --omit=optional \
  node-red-contrib-telegrambot@^16.3.2 \
  node-red-node-sqlite@^1.1.0 \
  node-red-node-watson

ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]
