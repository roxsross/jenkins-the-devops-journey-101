FROM node:16-alpine
LABEL project="DevSecOps"
LABEL owner="RoxsRoss"
ENV PORT=8080
WORKDIR /app
COPY ./ /app/
RUN npm install
EXPOSE 8080
CMD ["npm","start"]