/*
 * html5rl_cpp.rl
 * A wrapper around the HTML5 Ragel state machine to help aid the state
 * machine's development.
 */
#include <iostream>

using namespace std;

%% machine html5parser;
%% include "../../etc/html5parser.rl";
%% write data;

int main(int argc, char** argv) {
	const int BUFSIZE = 1024;
	char buffer[BUFSIZE];

	int have = 0;	// bytes in the buffer
	int space;	// space available in the buffer

	char *ts, *te;
	int cs, act;
	%% write init;

	bool done = false;
	while (!done) {
		space = BUFSIZE - have;
		if (space <= 0) {
			cerr << "CURRENT TOKEN TOO BIG" << endl;
			exit(1);
		}
		
		// read block of data
		char *p = buffer + have;
		cin.read(p, space);
		char *pe = p + cin.gcount();
		char *eof = 0;
		if (p == pe) {
			eof = pe;
			done = true;
		}

		// process block of data
		%% write exec;
		if (cs == html5parser_error) {
			cerr << "HTML5 PARSER ERROR" << endl;
			exit(1);
		}

		// preserve current token's prefix
		if (ts > 0) {
			have = pe - ts;
			memmove(buffer, ts, have);
			te = buffer + (te - ts);
			ts = buffer;
		} else {
			have = 0;
		}
	}

	return 0;
}

