#!/bin/sh

grunt
mkdir -p wat
cp -r dist/* wat/.

git checkout gh-pages
cp -r wat/* .
rm -rf wat

git add *
git commit -am 'auto-deploy'
git push origin gh-pages
rm -rf *

git checkout master
grunt
