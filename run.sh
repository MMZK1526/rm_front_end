#!/bin/sh

echo "PORT IS ${PORT}"

/app/dart-sdk/bin/dart pub global run dhttpd --host 0.0.0.0 --path="/app/build/web/" --port=${PORT}
