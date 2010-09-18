# Just a quick manual job to get things up and running

CC = gcc
CFLAGS = -Wall

OBJ = main.o html5.o
INC = html5.h
SM = html5.rl

html5: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o html5

$(OBJ): $(INC)

html5.c: html5.rl html5parser.rl
	ragel html5.rl -o html5.c

clean:
	rm -f $(OBJ) html5.c html5
