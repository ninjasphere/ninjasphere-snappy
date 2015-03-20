#!/bin/bash

. ../packaging.sh

begin-build-staging

	apply-template-staging

	snappy-build-staging

#clean-build-staging
