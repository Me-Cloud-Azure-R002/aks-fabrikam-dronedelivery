#! /bin/bash

: << example
    Example implementation of command-line arguments
    ./fruit.sh apple pear orange
    echo "The first fruit is: $1"
    echo "The second fruit is: $2"
    echo "The third fruit is: $3"
    echo "All fruits are: $@"
example

mkdir $1 && cd $1
npm init -y
npm install --save-dev vuepress

: << example
Finally, edit the scripts section of the package.json file to include the dev and build commands:

"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "docs-dev": "vuepress dev docs",
    "docs-build": "vuepress build docs"
},
example

# npm run docs-dev

# Project root
mkdir -p docs/{blog,.vuepress}
touch docs/README.md

# blog directory
mkdir docs/blog/{css,html,javascript}
touch docs/blog/{css,html}/{lists.md,README.md}
touch docs/blog/javascript/{functions.md,objects.md,README.md,strings.md,variables.md}
touch docs/blog/{README.md,http.md}

# .vuepress directory
mkdir docs/.vuepress/{components,theme}
touch docs/.vuepress/components/{Footer.vue,Hero.vue,Message.vue,Navbar.vue}
touch docs/.vuepress/config.js
mkdir docs/.vuepress/theme/{layouts,styles}
touch docs/.vuepress/theme/Layout.vue
touch docs/.vuepress/theme/layouts/{Blog.vue,Home.vue,Post.vue}
touch docs/.vuepress/theme/styles/{code.styl,custom-blocks.styl}

: << example
Finally, before we start building the blog, 
let`s establish some settings. In .vuepress/config.js:

module.exports = {
    title: "Front-end Web School",
    description: "Learn HTML, CSS, and JavaScript",
    head: [
    [
        "link",
        {
            rel: "stylesheet",
            href:
                "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.1/css/bulma.min.css"
    }
    ],
    [
        "link",
        {
            rel: "stylesheet",
            href: "https://use.fontawesome.com/releases/v5.6.1/css/all.css"
        }
    ]
    ]
};

example

: << example
Let`s start by preparing some content for our blog.
In the blog directory, we have html, css, and javascript subdirectories. Each blog subdirectory will play the role of a collection. 
So we`ll have the ability to organize the blog`s content by collections and to explore each collection individually.

The blog directory and all of its subdirectories each have a README.md file. This file will contain Front Matter section.
So the README.md file will contain:


---
title: Learn JavaScript Functions
date: 2018-12-12
categories: [Intermediate]
tags: [JavaScript, Function, Callback Function]
---

<!-- Your Markdown content here -->



For the css directory:

---
title: CSS
---

example

: << example

example

: << example

example

: << example

example

: << example

example