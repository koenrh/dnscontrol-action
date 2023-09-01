#!/bin/bash

# source: https://git.io/J86QD
grep -v -e '^\.\.\.0 corrections$' | \
grep -v -e '^0 corrections' | \
grep -v -e '\.\.\. (skipping)' | \
grep -v -e '^----- DNS Provider: ' | \
grep -v -e '^----- Registrar: ' | \
grep -v -e '^----- Getting nameservers from:' | \
grep -v -e '\[INFO: Diff2 algorithm in use. Welcome to the future!\]'
