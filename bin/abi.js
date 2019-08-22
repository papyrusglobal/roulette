#!/bin/sh
node -e "console.log(JSON.stringify(require('./build/contracts/Roulette.json').abi))"
