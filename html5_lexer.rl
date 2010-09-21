/*
 * html5_lexer.rl
 * A HTML5 parsing library
 */
#include <stdio.h>
#include "html5.h"

#define token(t)	printf("token: %s\n", t)
#define token_end()	printf("token end: "); print(val, s->p);
#define token_start(t)	printf("token start: %s\n", t); val = s->p;

char *END_TAG = "end tag";
char *SELF_CLOSE = "self close";
char *START_TAG = "start tag";
char *ATTRIBUTE = "attribute";
char *VALUE = "value";
char *TAG_NAME = "tag name";

byte *val;
void print(byte *s, byte *e) {
	while (s != e) {
		putc(*s++, stdout);
	}
	putc('\n', stdout);
}

%%{
	machine html5_lexer;
	include html5_grammar "html5_grammar.rl";

	main := html5_document;

	access s->;
	variable p s->p;
	variable pe s->pe;
	variable eof s->eof;

	write data;
}%%

void html5rl_init(rlstate *s) {
	%% write init;
	s->eof = 0;
	s->ts = 0;
	s->te = 0;
}

byte* html5rl_exec(rlstate *s, byte *p, byte *pe) {
	s->p = p;
	s->pe = pe;
	s->te = p + (s->te - s->ts);
	s->ts = p;
	%% write exec;
	return s->ts ? s->ts : s->pe;
}

void html5rl_eof(rlstate *s) {
	s->eof = s->p = s->pe;
	%% write exec;
}
