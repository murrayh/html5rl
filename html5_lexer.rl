/*
 * html5_lexer.rl
 * A HTML5 parsing library
 */
#include <stdio.h>
#include "html5.h"

#define token(t)					\
	token.type = t;					\
	token.start = token.end = s->p;

#define start_token(t)					\
	token.type = t;					\
	token.start = s->p;

#define might_end_token()				\
	for (i = 0; i < 4 - 1; ++i) {			\
		token_ends[i+1] = token_ends[i];	\
	}						\
	token_ends[0] = s->p;

#define end_token_2chars()				\
	token.end = token_ends[1];			\
	token.complete = true;

#define end_token()					\
	token.end = s->p;				\
	token.complete = true;

%%{
	machine html5_lexer;
	include html5_grammar "html5_tokens.rl";
	alphtype unsigned char;

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

	/* Local vars */
	int i;
	byte *token_ends[4];

	/* Lexer setup */
	html5token token;
	token.type = EXTEND_PREVIOUS;
	token.complete = false;
	token.start = token.end = s->p;

	%% write exec;

	if (s->cs == html5_lexer_error) {
		fprintf(stderr, "### Parse error : '");
		byte *p = s->p;
		while (p != s->pe) {
			if (*p == '\n') {
				fprintf(stderr, "\\n");
			} else {
				fprintf(stderr, "%c", *p);
			}
			++p;
		}
		fprintf(stderr, "'\n");
	}

	return token;
}

