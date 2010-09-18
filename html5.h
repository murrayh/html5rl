#define byte char

typedef struct rlstate {
	int cs;		// current state
	int act;
	char *p;	// data pointer
	char *pe;	// data end pointer
	char *eof;	// end of file pointer
	char *ts;	// token start
	char *te;	// token end
} rlstate;
	

void html5rl_init(rlstate *s);
byte *html5rl_exec(rlstate *s, byte *start, byte *end);
void html5rl_eof(rlstate *s);
