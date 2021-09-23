FROM node:14.17.6-alpine3.13 AS builder

WORKDIR /app

RUN apk add --no-cache git python make g++

COPY package*.json ./

RUN npm install

# Production container
FROM node:14-stretch-slim

WORKDIR /app

COPY . /app

COPY --from=builder /app/node_modules /app/node_modules

RUN npm run compile

ENTRYPOINT ["npm", "run"]

CMD ["deploy", "--", "--f", "2"]

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="HardHat Container" \
      org.label-schema.description="HardHat Deployment Container" \
      org.label-schema.url="https://vcs.manifoldfinance.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/manifoldfinance/vcs.git" \
      org.label-schema.vendor="CommodityStream" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
