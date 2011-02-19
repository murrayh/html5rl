/* HTML5 grammar based on
 * http://www.whatwg.org/specs/web-apps/current-work/multipage/
 */
%%{

machine html5_grammar;
include html5_grammar "html5_names.rl";

action pe				{ /* parse error */ }
action fhold				{ fhold; }
action token_self_close			{ token(SELF_CLOSE); fhold; fbreak; }
action token_start_tag			{ token(START_TAG); }
action token_end_tag			{ token(END_TAG); }
action token_doctype			{ token(DOCTYPE); }
action token_doctype_public		{ token(DOCTYPE_PUBLIC); }
action token_doctype_system		{ token(DOCTYPE_SYSTEM); }
action start_token_attribute		{ start_token(ATTRIBUTE); }
action start_token_comment		{ start_token(COMMENT); }
action start_token_value		{ start_token(VALUE); }
action start_token_doctype_name		{ start_token(DOCTYPE_NAME); }
action might_end_token			{ might_end_token(); }
action end_token			{ end_token(); fbreak; }
action end_token_2chars			{ end_token_2chars(); }

# tags
unquoted_value = (
	( uchar - uspc - uqt - ugt ) ( uchar - uspc - ugt )*
) >start_token_value %end_token;

single_quoted_value = (
	usqt ( uchar*) >start_token_value %end_token :>> usqt
);

double_quoted_value = (
	udqt ( uchar* ) >start_token_value %end_token :>> udqt
);

quoted_value = (
	single_quoted_value
	| double_quoted_value
);

value = (
	unquoted_value
	| quoted_value
);

attribute = (
	( uchar - uspc - ufslash - ugt ) ( uchar - uspc - ufslash - ugt - ueq )*
) >start_token_attribute %end_token;

attributes = (
	( attribute uspc* )
	| ( attribute uspc* ueq space* ( value uspc* )? )
	| ( ufslash ^ugt >fhold )
	| ( ufslash ugt @token_self_close ) 
)**;

tag_name =  (
	ualpha ( uchar - uspc - ufslash - ugt )*
) %end_token;

tag = ( tag_name <: uspc* attributes ugt );

start_tag = ( ult tag >token_start_tag );

end_tag = ( ult ufslash tag >token_end_tag );

# comments
regular_comment = (
	ult ubang udash udash ( uchar* )
		>start_token_comment
		%might_end_token
	:>> udash udash ( ubang | uspc+ )? ugt >end_token_2chars
);

bogus_comment1 = (
	ult ubang ( uchar* - ( udash udash ) - ndoctype )
		>start_token_comment
		%end_token
	:>> ugt
);

bogus_comment2 = (
	ult uqm ( uchar* )
		>start_token_comment
		%end_token
	:>> ugt
);

bogus_comment3 = (
	ult ufslash ( ( uchar - ualpha - ugt ) uchar* )
		>start_token_comment
		%end_token
	:>> ugt
);

comment = (
	regular_comment
	| bogus_comment1
	| bogus_comment2
	| bogus_comment3
);

# doctype
doctype_single_quoted_value = (
	usqt ( ^ugt* )
		>start_token_value
		%end_token
	:>> usqt
);

doctype_double_quoted_value = (
	udqt ( ^ugt* )
		>start_token_value
		%end_token
	:>> udqt
);

doctype_quoted_value = (
	doctype_single_quoted_value
	| doctype_double_quoted_value
);

doctype_name = (
	uspc+ ( uchar - ugt - uspc )+
		>start_token_doctype_name
		%end_token
);

doctype_public = (
	uspc+ 'PUBLIC'
		%token_doctype_public
	uspc+ doctype_quoted_value
);

doctype_system = (
	uspc+ 'SYSTEM'
		%token_doctype_system
	uspc+ doctype_quoted_value
);

doctype_attributes = (
	doctype_name doctype_public? doctype_system? space*
) <>^pe;

doctype = (
	ult ubang ndoctype
		%token_doctype
	space* ( ^ugt* | doctype_attributes )? <: ( ^ugt+ >pe )? ugt
);

html5_document = (
	start_tag
	| end_tag
	| comment
	| doctype
)**;

}%%
