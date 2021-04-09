create or replace procedure p_create_community(
		_title varchar, 
		_image_path varchar, 
		_description varchar, 
		_admin_id UUID,
		inout _id UUID default uuid_nil()
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

	insert into subscriptions (user_id, community_id, status)
	values (_admin_id, com_id, 'moderator');

	if (_image_path is not null) then
		call p_create_resource('communities/' || com_id || '/' || _image_path, 'image', com_id, image_id);
	
		update communities 
		set main_image = image_id
		where status = 'enabled'
		and title = _title;
	end if;

	_id = com_id;
end
$$

