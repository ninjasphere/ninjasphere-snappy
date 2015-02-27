#!/bin/sh
grep -Po '(?<=version: )(.+)' $(dirname $0)/$1/template/meta/package.yaml
