/*
 * html5rl.rl
 * A HTML5 parsing library
 */
#include <stdio.h>
#include "html5.h"

void openTag(byte *s, byte *e) {
	while (s != e) {
		putc(*s, stdout);
		++s;
	}
	putc('\n', stdout);
}

void closeTag(byte *s, byte *e) {
	openTag(s, e);
}

%%{
	machine html5parser;
	include "html5parser.rl";

	access s->;
	variable p s->p;
	variable pe s->pe;
	variable eof s->eof;

	write data;
}%%

void html5rl_init(rlstate *s) {
	s->cs = 0;
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
