# syntax=docker/dockerfile:1

FROM node:16-alpine as builder
WORKDIR /app
COPY . /app
RUN npm ci
RUN npm run build

FROM nginx
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]