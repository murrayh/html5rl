/*
 * html5parser.rl
 * An abstract HTML5 parsing state machine
 */
%%{

machine html5parser;

delim = 0x09 | 0x0A | 0x0C | 0x20;

tagchar = any - (delim | [/>]);
opentag = "<" alpha tagchar*;
closetag = "</" alpha tagchar*;

main := |*
	opentag => {
		openTag(s->ts + 1, s->te);
	};
	closetag => {
		closeTag(s->ts + 2, s->te);
	};
	any;
*|;

}%%
