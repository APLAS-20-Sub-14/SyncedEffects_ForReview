.DEFAULT_GOAL := install

install:
	ocamllex lexer.mll
	menhir parser.mly
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c parser.ml
	ocamlc -c lexer.ml
	ocamlc -c Pretty.ml

	ocamlc -c -o Rewriting.cmo  BackEnd/Rewriting.ml

	ocamlc -c -o Forward.cmo  FrontEnd/Forward.ml

	ocamlc -c -o sleek.cmo  BackEnd/sleek.ml

	ocamlc -c -o LTL_Traslator.cmo  LTL_Traslator.ml

	ocamlc -o hip parser.cmo  lexer.cmo Pretty.cmo Rewriting.cmo Forward.cmo

	ocamlc -o sleek parser.cmo lexer.cmo Pretty.cmo Rewriting.cmo sleek.cmo

	ocamlc -o ltl parser.cmo  lexer.cmo Pretty.cmo LTL_Traslator.cmo
	
	cp ltl /usr/local/bin/ltl
	
	cp hip /usr/local/bin/hip
	
	cp sleek /usr/local/bin/sleek
	
	cp ltl /usr/bin/ltl
	
	cp hip /usr/bin/hip
	
	cp sleek /usr/bin/sleek


clean:
	rm *.cmi
	rm *.cmo

	rm lexer.ml
	rm parser.ml
	rm parser.mli
	rm hip
	rm 