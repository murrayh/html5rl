/*
 * html5_lexer.rl
 * A HTML5 parsing library
 */
#include <stdio.h>
#include "html5.h"

#define SELF_CLOSE	1001
#define TAG_NAME	1002
#define EXTEND_PREVIOUS	1003

#define token(t)	token.type = t; token.start = token.end = s->p;
#define token_start(t)	token.start = s->p; \
			if (token.type == UNKNOWN) token.type = t
#define token_end()	token.end = s->p; token.complete = true; \
			if (token.type == UNKNOWN) token.type = EXTEND_PREVIOUS

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

html5token html5rl_exec(rlstate *s, byte *p, byte *pe) {
	/* Ragel setup */
	s->p = p;
	s->pe = pe;
	s->te = p + (s->te - s->ts);
	s->ts = p;
	if (s->p == s->pe) {
		s->eof = s->p;
	}

	/* Lexer setup */
	html5token token;
	token.type = UNKNOWN;
	token.complete = false;
	token.start = token.end = s->pe;

	%% write exec;

	return token;
}

