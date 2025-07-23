#!/bin/sh
set -ex

# Start nginx in the background
nginx -g 'daemon off;' &

# Start npm
# already server.js is copied to /app in Docker Build stage from /app/.next/standalone/server.js
# setting environment variable for hostname to allow external access
export HOSTNAME=0.0.0.0

node server.js
