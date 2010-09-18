/*
 * html5parser.rl
 * An abstract HTML5 parsing state machine
 */
%%{

machine html5parser;

delim = 0x09 | 0x0A | 0x0C | 0x20;
tag_delim = delim | [/>];

open_tag = "<" alpha (any - tag_delim)*;
close_tag = "</" alpha (any - tag_delim)*;

main := |*
	open_tag => {
		openTag(s->ts + 1, s->te);
	};
	close_tag => {
		closeTag(s->ts + 2, s->te);
	};
	any;
*|;

}%%
