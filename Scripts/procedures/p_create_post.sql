create or replace procedure p_create_post(
		_content JSONB, 
		_type POST_TYPE_ENUM, 
		_author_type AUTHOR_TYPE_ENUM, 
		_author_id UUID,
		_attachments varchar[],
		inout _post_id UUID default uuid_nil()
		)
	language plpgsql
as
$$
declare
	post_id UUID;
	_attachment varchar;
	image_id UUID;
begin
	insert into posts("content", "date", "type", author_type, author_id)
	values (_content, now(), _type, _author_type, _author_id) returning id into post_id;

	foreach _attachment in array _attachments loop
		call p_create_resource('posts/' || post_id || '/' || _attachment, 'image', post_id, image_id);
	end loop;

	_post_id = post_id;
end
$$

