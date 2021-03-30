create or replace procedure p_create_user(
		_first_name varchar, 
		_last_name varchar, 
		_username varchar, 
		_password varchar, 
		_gender GENDER_ENUM,
		_avatar_path varchar,
		_role ROLE_ENUM,
		inout _id UUID default uuid_nil()
		)
	language plpgsql
as
$$
declare
	user_id UUID;
	image_id UUID;
begin
	insert into users(first_name, last_name, username, "password", gender, avatar, "role", status)
	values (_first_name, _last_name, _username, _password, _gender, null, _role, 'enabled') returning id into user_id;

	if (_avatar_path is not null) then
		call p_create_resource(_avatar_path, 'image', user_id, image_id);
	
		update users
		set avatar = image_id
		where status = 'enabled'
		and "role" = _role
		and username = _username;
	end if;

	_id = user_id;
end
$$
