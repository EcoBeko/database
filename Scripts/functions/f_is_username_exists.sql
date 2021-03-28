create or replace function f_is_username_exists(_username varchar, _role varchar)
	returns boolean
	language plpgsql
as
$$
declare
	user_count integer;
begin 
	select count(*) into user_count from users
	where role = _role and
	status = 'enabled' and
	username = _username;

	return user_count > 0;
end
$$