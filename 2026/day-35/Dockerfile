FROM node:22 AS builder

WORKDIR /app

COPY app.js .

FROM node:22-alpine

WORKDIR /app

COPY --from=builder /app/app.js .

CMD ["node", "app.js"]
