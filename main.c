/*
 * main.c
 * A wrapper around the HTML5 Ragel state machine to help aid the state
 * machine's development.
 */
#include <stdio.h>
#include <string.h>
#include "html5.h"

#define bool int
#define false 0
#define true 1

int main(int argc, char** argv) {
	static const int BUFSIZE = 1024;
	byte buffer[BUFSIZE];

	byte *bstart = buffer;
	byte *bend = buffer + BUFSIZE;
	byte *start;
	byte *end = bstart;
	size_t count;

	rlstate s;
	html5rl_init(&s);

	bool done = false;
	while (!done) {
		count = fread(bstart, sizeof(byte), bend - end, stdin);
		if (count <= 0) {
			html5rl_eof(&s);
			done = true;
		} else {
			end += count;
			start = html5rl_exec(&s, bstart, end);
			memmove(bstart, start, end - start);
			end -= (start - bstart);

			if (end == bend) {
				fprintf(stderr, "CURRENT TOKEN TOO BIG\n");
				done = true;
			}
		}
	}

	return 0;
}

