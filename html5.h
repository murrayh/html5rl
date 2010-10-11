#ifndef byte
	#define byte char
#endif

#ifndef bool
	#define bool int
	#define true 1
	#define false 0
#endif

#define UNKNOWN		0
#define START_TAG	1
#define END_TAG		2
#define ATTRIBUTE	3
#define VALUE		4
#define COMMENT		5

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
	char *start;
	byte *end;
} html5token;

void html5rl_init(rlstate *s);
html5token html5rl_exec(rlstate *s, byte *start, byte *end);
