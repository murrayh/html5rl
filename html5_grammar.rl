/* HTML5 grammar based on
 * http://www.whatwg.org/specs/web-apps/current-work/multipage/
 */
%%{

	machine html5_grammar;

	action fhold				{ fhold; }
	action token_end_tag			{ token(END_TAG); }
	action token_self_close			{ token(SELF_CLOSE); fhold; fbreak; }
	action token_start_tag			{ token(START_TAG); }
	action token_might_end			{ token_might_end(); }
	action token_end			{ token_end(); fbreak; }
	action token_end_2chars			{ token_end_2chars(); }
	action token_start_attribute		{ token_start(ATTRIBUTE); }
	action token_start_comment		{ token_start(COMMENT); }
	action token_start_value		{ token_start(VALUE); }

	unquoted_value = (
		(any - (space | ['">])) (any - (space | '>'))*
	) >token_start_value %token_end;

	single_quoted_value = (
		"'" (any*)
			>token_start_value
			%token_end
		:>> "'"
	);

	double_quoted_value = (
		'"' (any*)
			>token_start_value
			%token_end
		:>> '"'
	);

	value = (
		unquoted_value |
		single_quoted_value |
		double_quoted_value
	);

	attribute = (
		(any - (space | [/>])) (any - (space | [/>=]))*
	) >token_start_attribute %token_end;

	tag_attributes = (
		(attribute space*)
		| (attribute space* '=' space* (value space*)?)
		| ('/' [^>] >fhold)
		| ('/>' @token_self_close) 
	)**;

	tag_name =  (
		alpha (any - (space | [/>]))*
	) %token_end;

	tag = (
		tag_name <: space* tag_attributes '>'
	);

	start_tag = ('<' (tag) >token_start_tag);

	end_tag = ('</' (tag) >token_end_tag);

	regular_comment = (
		'<!--' (any*)
			>token_start_comment
			%token_might_end
		:>> ('--' ('!' | (space+))? '>')
	) %token_end_2chars;

	bogus_comment1 = (
		'<?' (any*)
			>token_start_comment
			%token_end
		:>> '>'
	);

	bogus_comment2 = (
		'</' ( (any - (alpha | '>')) (any*) )
			>token_start_comment
			%token_end
		:>> '>'
	);

	comment = (regular_comment | bogus_comment1 | bogus_comment2);

	html5_document = (
		start_tag | end_tag | (space+) | comment
	)**;

}%%
