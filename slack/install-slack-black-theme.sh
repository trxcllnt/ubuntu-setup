#!/usr/bin/env bash

cat edits.js | sudo tee -a /usr/lib/slack/resources/app.asar.unpacked/src/static/index.js
cat edits.js | sudo tee -a /usr/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js

