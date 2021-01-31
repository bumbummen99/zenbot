FROM node:10 as builder
ADD . /app
WORKDIR /app
RUN npm i -g node-gyp webpack webpack-cli
RUN npm i --unsafe

FROM node:10-alpine

RUN apk add nano

COPY zenbot.sh /usr/local/bin/zenbot

WORKDIR /app
RUN chown -R node:node /app

COPY --chown=node . /app
COPY --chown=node --from=builder /usr/local/lib/node_modules/ /usr/local/lib/node_modules/
COPY --chown=node --from=builder /app/node_modules /app/node_modules/

RUN npm i -g node-gyp webpack webpack-cli

RUN node post_install.js

USER node
ENV NODE_ENV production

ENTRYPOINT ["/usr/local/bin/zenbot"]
CMD ["trade","--paper"]
