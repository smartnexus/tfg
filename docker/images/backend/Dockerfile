FROM node:12.18.1-alpine AS builder

WORKDIR /app

COPY package*.json .
RUN npm install

COPY . .
RUN npm run build

FROM node:12.18.1-alpine AS production
ENV MONGO_TOOLS_VERSION=4.2.1-r1
ENV NODE_ENV=production

RUN apk add --no-cache mongodb-tools=${MONGO_TOOLS_VERSION}
RUN apk add bash

WORKDIR /icu

RUN npm init -y && npm install full-icu

WORKDIR /app

COPY --from=builder /app/dist dist
COPY --from=builder /app/package*.json .
RUN npm ci --only=production
COPY public public
COPY src/scripts scripts

VOLUME [ "/app/parts" ]
VOLUME [ "/app/covers" ]
VOLUME [ "/app/media" ]
VOLUME [ "/app/backup" ]

#CMD ["/bin/bash", "scripts/wait.sh", "\"$WAIT_FOR\"", "-s", "--", "scripts/start.sh"]
ENTRYPOINT /bin/bash scripts/wait.sh "$WAIT_FOR" -s -- scripts/start.sh

EXPOSE 3000