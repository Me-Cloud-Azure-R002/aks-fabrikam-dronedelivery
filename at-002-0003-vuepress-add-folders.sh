
echo "Creating blog directory structure ... "
## blog directory
mkdir docs/blog/{css,html,javascript}
touch docs/blog/{css,html}/{lists.md,README.md}
../at-002-0002-vuepress-edit-readme.sh "docs/blog/css/README.md"
../at-002-0002-vuepress-edit-readme.sh "docs/blog/html/README.md"
touch docs/blog/javascript/{functions.md,objects.md,README.md,strings.md,variables.md}
../at-002-0002-vuepress-edit-readme.sh "docs/blog/javascript/README.md"
touch docs/blog/{README.md,http.md}
../at-002-0002-vuepress-edit-readme.sh "docs/blog/README.md"


## .vuepress directory
# echo "Creating .vuepress directory structure ... "
# mkdir docs/.vuepress/{components,theme}
# touch docs/.vuepress/components/{Footer.vue,Hero.vue,Message.vue,Navbar.vue}
# touch docs/.vuepress/config.js
# mkdir docs/.vuepress/theme/{layouts,styles}
# touch docs/.vuepress/theme/Layout.vue
# touch docs/.vuepress/theme/layouts/{Blog.vue,Home.vue,Post.vue}
# touch docs/.vuepress/theme/styles/{code.styl,custom-blocks.styl}
