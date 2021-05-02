#!/usr/bin/env bash

set -e

echo "Benchmark http-server-classic.js"
echo "--------------------------------"
node src/http-server-classic.js &
SERVER_PID=$!
node_modules/.bin/autocannon http://localhost:8000
kill $SERVER_PID

sleep 1

echo ""
echo "Benchmark http-server-iterator-await.js"
echo "---------------------------------------"
node src/http-server-iterator-await.js &
SERVER_PID=$!
node_modules/.bin/autocannon http://localhost:8000
kill $SERVER_PID

sleep 1

echo ""
echo "Benchmark http-server-iterator-no-await.js"
echo "------------------------------------------"
node src/http-server-iterator-no-await.js &
SERVER_PID=$!
node_modules/.bin/autocannon http://localhost:8000
kill $SERVER_PID
