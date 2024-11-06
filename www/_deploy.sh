#!/bin/bash

set -e

JEKYLL_ENV=production bundle exec jekyll build

rsync -vrpc --delete ./_site/ fcixadmin@griffin1.fcix.net:/var/www/mm.fcix.net/

