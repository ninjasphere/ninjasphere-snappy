#!/bin/sh
grep -Po '(?<=version: )(.+)' $(dirname $0)/template/meta/package.yaml
