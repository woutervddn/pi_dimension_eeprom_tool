#!/bin/bash

typeset -i id=$(cat id-file)

echo $id

echo "updating"

(( id++ ))

echo $id

echo "writing to file"

echo $id > id-file
