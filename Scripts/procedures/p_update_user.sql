create or replace procedure p_update_user(
		_id UUID,
		_first_name varchar, 
		_last_name varchar, 
		_password varchar, 
		_gender GENDER_ENUM,
		_role ROLE_ENUM
		)
	language plpgsql
as
$$
begin
	if (_password is null) then
		update users
		set 
			first_name = _first_name,
			last_name = _last_name,
			gender = _gender
		where status = 'enabled'
		and "role" = _role
		and id = _id;
	else
		update users
		set 
			first_name = _first_name,
			last_name = _last_name,
			"password" = _password,
			gender = _gender
		where status = 'enabled'
		and "role" = _role
		and id = _id;
	end if;
end
$$
