create or replace procedure p_create_community(
		_title varchar, 
		_image_path varchar, 
		_description varchar, 
		_admin_id UUID,
		inout _id UUID
		)
	language plpgsql
as
$$
declare
	com_id UUID;
	image_id UUID;
begin
	insert into communities (title, main_image, description, admin_id, status)
	values (_title, null, _description, _admin_id, 'enabled') returning id into com_id;

	if (_image_path is not null) then
		call p_create_resource(_image_path, 'image', com_id, image_id);
	
		update communities 
		set main_image = image_id
		where status = 'enabled'
		and title = _title;
	end if;

	_id = com_id;
end
$$