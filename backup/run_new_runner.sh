#!/usr/bin/env sh
rm -rf runner/
cd chaos/
git pull origin trials
cd ..
cp -r chaos/backup/runner .
cd runner
mkdir results
sh ./runner.sh

