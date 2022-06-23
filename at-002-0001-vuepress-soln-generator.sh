#!/bin/bash

# Inside an Existing Project

## install as a local dependency

mkdir $1 && cd $1
npm init --yes # OR yarn init --yes
npm install --save-dev vuepress # OR yarn install --save-dev vuepress
npm install --save-dev json

# Update package.json
### json --in-place -f package.json -e "this.scripts.test=\"echo \\\'Error: no test specified\\\" && exit 1\""
json --in-place -f package.json -c 'this.scripts.debug="vuepress dev docs"'
json --in-place -f package.json -c 'this.scripts.build="vuepress build docs"'

: << warning-text
WARNING:
It is currently recommended to use Yarn instead of npm 
when installing VuePress into an existing project that has webpack 3.x as a dependency. 
Npm fails to generate the correct dependency tree in this case.
warning-text

# create a docs directory:

## Project root
mkdir -p docs/{blog,.vuepress}
touch docs/README.md
../at-002-0002-vuepress-edit-readme.sh "docs/README.md"

## blog directory
## .vuepress directory
../at-002-0003-vuepress-add-folders.sh

# build
# npm run build # OR yarn docs:build

# start writing
npm run debug # OR yarn docs:dev




