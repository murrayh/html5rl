/*
 * main.c
 * A wrapper around the HTML5 Ragel state machine to help aid the state
 * machine's development.
 */
#include <stdio.h>
#include <string.h>
#include "html5.h"

void print_token(html5token token);
void print_bytes(byte *start, byte *end);

int main(int argc, char** argv) {
	static const int BUFSIZE = 1024;
	byte buffer[BUFSIZE];

	byte *start;
	byte *end;
	size_t count;

	rlstate s;
	html5token token;
	html5rl_init(&s);

	bool done = false;
	while (!done) {
		count = fread(buffer, sizeof(byte), BUFSIZE, stdin);
		if (count <= 0) {
			html5rl_exec(&s, NULL, NULL);
			done = true;
		} else {
			start = buffer;
			end = buffer + count;
			do
			{
				token = html5rl_exec(&s, start, end);
				start = s.p;
				print_token(token);
			}
			while (token.end != end);
		}
	}

	return 0;
}

bool first = true;
char indent[20] = { '\0' };
void print_token(html5token token) {
	switch (token.type) {
	case START_TAG:
		if (first) {
			first = false;
		} else {
			putc('\n', stdout);
		}
		printf("%s<", indent);
		print_bytes(token.start, token.end);
		putc('>', stdout);
		strcat(indent, "  ");
		break;
	
	case END_TAG:
		if (first) {
			first = false;
		} else {
			putc('\n', stdout);
		}
		printf("%s</", indent);
		print_bytes(token.start, token.end);
		putc('>', stdout);
		strcat(indent, "  ");
		break;
	
	case ATTRIBUTE:
		printf("\n%s", indent);
		print_bytes(token.start, token.end);
		break;

	case VALUE:
		putc('=', stdout);
		print_bytes(token.start, token.end);
		break;
	
	case COMMENT:
		printf("\n%s<!-- ", indent);
		print_bytes(token.start, token.end);
		printf(" -->");
		break;

	default:
		printf("\nhere %d, %d\n", token.type, token.end - token.start);
		break;
	}
}

void print_bytes(byte *start, byte *end) {
	while (start != end) {
		putc(*start++, stdout);
	}
}
