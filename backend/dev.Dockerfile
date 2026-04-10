FROM node:20-alpine

WORKDIR /app

RUN npm install -g nodemon

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001

CMD ["nodemon", "--exec", "node", "-r", "dotenv/config", "index.js"]