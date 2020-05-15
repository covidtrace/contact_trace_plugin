# contact_trace_plugin

A Flutter plugin that exposes the Google/Apple Exposure Notification API

## Generating protobuf dart files

Follow the instructions to install the `protoc` CL tool here:
https://pub.dev/packages/protoc_plugin

```bash
pub global activate protoc_plugin

protoc --plugin=/Users/{USERNAME}/.pub-cache/bin/protoc-gen-dart --dart_out=. lib/diagnosisKeyURL.proto
```
