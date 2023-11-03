.PHONY: test check
.PHONY: ray check

build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop lib

utop-file:
	export DISPLAY=:0.0 && (echo '#require "graphics";;' && echo 'open Graphics;;' && echo '#use "lib/player.ml";;' && echo '#use "lib/window.ml";;' && echo 'Window.init();;') | utop

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe

ray:
	OCAMLRUNPARAM=b dune exec ray/main.exe

opamray: 
	opam depext raylib
	opam install raylib

opam: 
	opam update
	opam upgrade
	opam install graphics
	opam install spectrum

zip:
	dune clean
	zip -r Final-Project.zip . 
	dune build