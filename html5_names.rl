/* The names used to define tokens.
 * 
 * By abstracting out the character encoding, we might be
 * able to instantiate a ragel state machine for each
 * different character encoding. So each character encoding
 * will be performant.
 */
%%{

machine html5_grammar;

# For starters, just use plain ASCII

uchar = any;

# characters
uamp = '&';
ubang = '!';
udash = '-';
udqt = '"';
ueq = '=';
ufslash = '/';
ugt = '>';
uhash = '#';
ult = '<';
uqm = '?';
usqt= "'";

# common collections
ualpha = alpha;
umspc = 0x09 | 0x0A | 0x0C | 0x0D | 0x20;
uqt = usqt | udqt;
uspc = 0x09 | 0x0A | 0x0C | 0x20;

# doctype names
ndoctype = 'DOCTYPE';
npublic = 'PUBLIC';
nsystem = 'SYSTEM';

# tag names
nbody = /body/i;
nhead = /head/i;
nscript = /script/i;

}%%
