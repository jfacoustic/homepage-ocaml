(lang dune 3.20)

(name homepage)

(generate_opam_files true)

(source
  (github jfacoustic/ocaml_homepage))

(maintainers "Josh Mathews <joshfeltonm@gmail.com>")
(authors "Josh Mathews <joshfeltonm@gmail.com>")

(license MIT)

(package
  (name homepage)
  (synopsis "Josh Mathews' homepage")
  (description "Homepage written in OCaml with blog")
  (depends ocaml dream-html))
