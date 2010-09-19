/*
 * html5parser.rl
 * An abstract HTML5 parsing state machine
 */
%%{

machine html5parser;

delim = 0x09 | 0x0A | 0x0C | 0x20;

tagchar = any - (delim | [/>]);
starttag = "<" alpha tagchar*;
endtag = "</" alpha tagchar*;

in_body := |*
	starttag => {
		starttag();
		fgoto in_attrs;
	};
	endtag => {
		endtag();
		fgoto in_attrs;
	};
	any;
*|;

in_attrs := |*
	attrchar = any - (delim | [/>=]);

	"/>" | ">" => {
		fgoto in_body;
	};
	(attrchar | "=") attrchar* => {
		attr();
	};
	any;
*|;

main := any @{
	fhold;
	fnext in_body;
};

}%%
