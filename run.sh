#!/bin/bash

dart pub get
flutter build web
dart pub global activate dhttpd
dart pub global run dhttpd --path build/web/ -p $PORT

