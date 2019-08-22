const express = require('express');
const http = require('http');
const path = require('path');

const app = express();
app.use(express.static(path.join(__dirname, 'public')));

const port = process.env.PORT || 3000;
const host = process.env.HOST || '0.0.0.0';
const server = http.Server(app);
module.exports = server.listen(port, host, () => {
  console.log(`Running server on ${host}:${port}...`);
});
