const express = require('express');
const { exec } = require('child_process');
const jwt = require('jsonwebtoken');
const app = express();

const SECRET = "supersecreto123";            // secreto hardcodeado

app.get('/ping', (req, res) => {
  exec('ping -c 1 ' + req.query.host, (e, out) => res.send(out)); // inyección de comandos
});

app.get('/eval', (req, res) => {
  res.send(String(eval(req.query.code)));    // eval de entrada del usuario
});

app.get('/token', (req, res) => res.send(jwt.sign({ u: 'admin' }, SECRET)));

app.listen(3001);
