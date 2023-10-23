build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop lib

utop-file:
	export DISPLAY=:0.0 && (echo '#require "graphics";;' && echo 'open Graphics;;' && echo '#use "lib/player.ml";;' && echo 'init();;') | utop

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe
