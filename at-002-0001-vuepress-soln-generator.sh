#!/bin/bash

# Inside an Existing Project

## install as a local dependency

mkdir $1 && cd $1
npm init --yes # OR yarn init --yes
npm install --save-dev vuepress # OR yarn install --save-dev vuepress

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

## blog directory
mkdir docs/blog/{css,html,javascript}
touch docs/blog/{css,html}/{lists.md,README.md}
touch docs/blog/javascript/{functions.md,objects.md,README.md,strings.md,variables.md}
touch docs/blog/{README.md,http.md}

## .vuepress directory
mkdir docs/.vuepress/{components,theme}
touch docs/.vuepress/components/{Footer.vue,Hero.vue,Message.vue,Navbar.vue}
touch docs/.vuepress/config.js
mkdir docs/.vuepress/theme/{layouts,styles}
touch docs/.vuepress/theme/Layout.vue
touch docs/.vuepress/theme/layouts/{Blog.vue,Home.vue,Post.vue}
touch docs/.vuepress/theme/styles/{code.styl,custom-blocks.styl}

# Update package.json
npm install --save-dev json
# json --in-place -f package.json -e "this.scripts.test=\"echo \\\'Error: no test specified\\\" && exit 1\""
json --in-place -f package.json -c 'this.scripts.debug="vuepress dev docs"'
json --in-place -f package.json -c 'this.scripts.build="vuepress build docs"'

# start writing
npm run debug # OR yarn docs:dev

# build
# npm run build # OR yarn docs:build



