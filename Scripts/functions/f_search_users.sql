create or replace function f_search_users(
		_first_name varchar, 
		_last_name varchar, 
		_gender GENDER_ENUM
		)
	returns setof users
	language plpgsql
as
$$
begin
	return query
	select * from users
	where (position(_first_name in first_name) not in (0) or _first_name is null)
	and (position(_last_name in last_name) not in (0) or _last_name is null)
	and (gender = _gender or _gender is null);
end
$$