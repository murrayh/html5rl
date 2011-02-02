/* HTML5 grammar based on
 * http://www.whatwg.org/specs/web-apps/current-work/multipage/
 */
%%{

	machine html5_grammar;

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
		(any - (space | ['">])) (any - (space | '>'))*
	) >start_token_value %end_token;

	single_quoted_value = (
		"'" (any*)
			>start_token_value
			%end_token
		:>> "'"
	);

	double_quoted_value = (
		'"' (any*)
			>start_token_value
			%end_token
		:>> '"'
	);

	quoted_value = (single_quoted_value | double_quoted_value);

	value = (unquoted_value	| quoted_value);

	attribute = (
		(any - (space | [/>])) (any - (space | [/>=]))*
	) >start_token_attribute %end_token;

	tag_attributes = (
		(attribute space*)
		| (attribute space* '=' space* (value space*)?)
		| ('/' [^>] >fhold)
		| ('/>' @token_self_close) 
	)**;

	tag_name =  (
		alpha (any - (space | [/>]))*
	) %end_token;

	tag = (
		tag_name <: space* tag_attributes '>'
	);

	start_tag = ('<' (tag) >token_start_tag);

	end_tag = ('</' (tag) >token_end_tag);

	# comments
	regular_comment = (
		'<!--' (any*)
			>start_token_comment
			%might_end_token
		:>> ('--' ('!' | (space+))? ('>' >end_token_2chars))
	);

	bogus_comment1 = (
		'<!' (any* - ('DOCTYPE' any*) - ('--' any*))
			>start_token_comment
			%end_token
		:>> '>'
	);

	bogus_comment2 = (
		'<?' (any*)
			>start_token_comment
			%end_token
		:>> '>'
	);

	bogus_comment3 = (
		'</' ( (any - (alpha | '>')) (any*) )
			>start_token_comment
			%end_token
		:>> '>'
	);

	comment = (regular_comment | bogus_comment1 | bogus_comment2 | bogus_comment3);

	# doctype
	doctype_single_quoted_value = (
		"'" ([^>]*)
			>start_token_value
			%end_token
		:>> "'"
	);

	doctype_double_quoted_value = (
		'"' ([^>]*)
			>start_token_value
			%end_token
		:>> '"'
	);

	doctype_quoted_value = (doctype_single_quoted_value | doctype_double_quoted_value);

	doctype_name = (
		space+ (any - ('>' | space))+
			>start_token_doctype_name
			%end_token
	);

	doctype_public = space+ 'PUBLIC' %token_doctype_public space+ doctype_quoted_value;

	doctype_system = space+ 'SYSTEM' %token_doctype_system space+ doctype_quoted_value;

	doctype = (
		'<!DOCTYPE' %token_doctype space* (doctype_name doctype_public? doctype_system?)? space* <: ([^>]+)? '>'
	);

	html5_document = (
		start_tag | end_tag | (space+) | comment | doctype
	)**;

}%%
