#!/bin/bash
bundle exec ejekyll
cd _site
rm Gem*
git init
git add .
git commit -m 'update'
git remote add origin git@github.com:terro/terro.github.com.git
git push -f
