create or replace procedure p_create_post(
		_content JSONB, 
		_type POST_TYPE_ENUM, 
		_author_type AUTHOR_TYPE_ENUM, 
		_author_id UUID
		)
	language plpgsql
as
$$
declare
begin
	insert into posts("content", "date", "type", author_type, author_id)
	values (_content, now(), _type, _author_type, _author_id);
end
$$