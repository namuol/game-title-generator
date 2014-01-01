#!/bin/sh

grunt
mkdir -p wat
mv dist/* wat/.

git checkout gh-pages
mv wat/* .
rm -rf wat

git add *.html *.json *.css support
git commit -am 'auto-deploy'
git push origin gh-pages

git checkout master
grunt
