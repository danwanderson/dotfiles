#!/usr/bin/env bash

git checkout master
git branch -m master main
git fetch
git branch --unset-upstream
git branch -u origin/main
