# Just a quick manual job to get things up and running

CC=gcc
CFLAGS=-Wall -Wextra
RAGEL=ragel

GEN=html5.c
OBJ=html5.o main.o
EXE=html5
RL=html5_lexer.rl html5_tokens.rl html5_names.rl

$(EXE): $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<
	
$(GEN): $(RL) html5.h
	$(RAGEL) html5_lexer.rl -o $@

clean:
	$(RM) $(OBJ) $(GEN)

clobber: clean
	$(RM) $(EXE)
	$(RM) *.png

%.png: $(RL)
	$(RAGEL) -p -V -M $(@:.png=) html5_lexer.rl | dot -Tpng > $@

.PHONY: clean clobber
