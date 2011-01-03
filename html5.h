#ifndef byte
	#define byte char
#endif

#ifndef bool
	#define bool int
	#define true 1
	#define false 0
#endif

#define EXTEND_PREVIOUS	0
#define START_TAG	1
#define END_TAG		2
#define SELF_CLOSE	3
#define ATTRIBUTE	4
#define VALUE		5
#define COMMENT		6

typedef struct rlstate {
	int cs;		// current state
	int act;
	char *p;	// data pointer
	char *pe;	// data end pointer
	char *eof;	// end of file pointer
	char *ts;	// token start
	char *te;	// token end
} rlstate;

typedef struct html5token {
	int type;
	bool complete;
	byte *start;
	byte *end;
} html5token;

void html5rl_init(rlstate *s);
html5token html5rl_exec(rlstate *s, byte *start, byte *end);
