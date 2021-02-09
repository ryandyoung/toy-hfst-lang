# Makefile syntax
# <target_file> : <dependency1> ...
# <TAB> command to produce target file

# If the dependencies or recipe need to take up more than one line, the line
# must be continued using a backslash.

all :	gen_mya.hfstol \
	ana_mya.hfstol \
	ana_mya.png \
	# lexicon_mya.png

lexicon_mya.lexc : root_mya.lexc nouns_mya.lexc verbs_mya.lexc
	cat root_mya.lexc nouns_mya.lexc verbs_mya.lexc > lexicon_mya.lexc

gen_mya.hfst : lexicon_mya.lexc
	hfst-lexc <lexicon_mya.lexc >gen_mya.hfst

gen_mya.hfstol : gen_mya.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i gen_mya.hfst -o gen_mya.hfstol

ana_mya.hfst : gen_mya.hfst
	hfst-invert -i gen_mya.hfst -o ana_mya.hfst

ana_mya.hfstol : ana_mya.hfst
	hfst-fst2fst --optimized-lookup-unweighted -i ana_mya.hfst -o ana_mya.hfstol

ana_mya.png : ana_mya.hfst
	hfst-fst2txt ana_mya.hfst | python3 att2dot.py | dot -T png -o ana_mya.png

# lexicon_mya.png : lexicon_mya.lexc
	# python3 lexc2dot.py <lexicon_mya.lexc | dot -T png -o lexicon_mya.png  # BUG

.PHONY : clean
clean :
	-rm *.hfst *.hfstol lexicon_mya.lexc

.PHONY : test
test :
	sh tests.sh  # sh is a command to run the argument filename as a shell script (usually bash)
