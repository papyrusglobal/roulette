#!/bin/sh
node -e "console.log('const abi =', JSON.stringify(require('./build/contracts/RouletteInterface.json').abi))" >../smart-roulette-frontend/abi.js
