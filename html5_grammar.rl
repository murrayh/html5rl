/* HTML5 grammar based on
 * http://www.whatwg.org/specs/web-apps/current-work/multipage/
 */
%%{

	machine html5_grammar;

	action token_end_tag		{ token(END_TAG); }
	action token_self_close		{ token(SELF_CLOSE); }
	action token_start_tag		{ token(START_TAG); }
	action token_end		{ token_end(); }
	action token_start_attribute	{ token_start(ATTRIBUTE); }
	action token_start_value	{ token_start(VALUE); }
	action token_start_tag_name	{ token_start(TAG_NAME); }

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
		attribute space* (('=' space* value) $1)? space*
	)**;

	tag_name =  (
		alpha (any - space - [/>])*
	) >token_start_tag_name %token_end;

	tag = (
		tag_name (space+ tag_attributes)? space* ('/' >token_self_close)? '>'
	);

	start_tag = ('<' (tag) >token_start_tag);

	end_tag = ('</' (tag) >token_end_tag);

	html5_document = (
		start_tag | end_tag | (space+)
	)**;

}%%
