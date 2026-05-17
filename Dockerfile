FROM nodered/node-red:latest

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends sqlite3 \
  && rm -rf /var/lib/apt/lists/*
USER node-red

COPY db/init.sql /opt/lyvia/init.sql
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
USER root
RUN chmod +x /docker-entrypoint.sh
USER node-red

RUN npm install --unsafe-perm --no-update-notifier --no-fund --omit=dev --omit=optional \
  node-red-contrib-telegrambot@^16.3.2 \
  node-red-node-sqlite@^1.1.0 \
  node-red-node-watson

ENTRYPOINT ["/docker-entrypoint.sh"]
