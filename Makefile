.PHONY: test check
.PHONY: ray check

bisect: bisect-clean
	-dune exec --instrument-with bisect_ppx --force test/main.exe
	bisect-ppx-report html

bisect-clean:
	rm -rf _coverage bisect*.coverage

build:
	dune build

cloc:
	dune clean
	cloc --by-file --include-lang=OCaml .
	dune build

clean: bisect-clean
	dune clean

clear-stats:
	rm player_data/*_stats.txt

doc: 
	dune build @doc
	@echo Documentation is located at: _build/default/_doc/_html/index.html  

utop:
	OCAMLRUNPARAM=b dune utop lib

utop-file:
	export DISPLAY=:0.0 && (echo '#require "graphics";;' && echo 'open Graphics;;' && echo '#use "lib/player.ml";;' && echo '#use "lib/window.ml";;' && echo 'Window.init();;') | utop

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe

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