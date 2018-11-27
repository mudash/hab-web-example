pkg_name=hello-hab-site
pkg_origin=chefshafique
pkg_version="0.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("Apache-2.0")

do_build() {
   #"package prefix is: ${pkg_prefix}"
   return 0
}
 
do_install() {
  echo "package prefix is: ${pkg_prefix}"
  mkdir -p "${pkg_prefix}/dist"
  cp -v index.html "${pkg_prefix}/dist/"
}
