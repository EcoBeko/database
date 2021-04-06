create or replace function f_search_users(
		_first_name varchar, 
		_last_name varchar, 
		_gender GENDER_ENUM
		)
	returns table(
		id UUID,
		first_name varchar,
		last_name varchar,
		username varchar,
		gender GENDER_ENUM,
		avatar varchar
	)
	language plpgsql
as
$$
declare
	_limit int = null;
begin
	if _first_name is null and _last_name is null and _gender is null then
		_limit = 1000;
	end if;
	return query
	select 
		u.id,
		u.first_name,
		u.last_name,
		u.username,
		u.gender,
		(select r."path" from resources r where r.id = u.avatar) as avatar
	from users u
	where f_str_search(u.first_name, _first_name)
	and f_str_search(u.last_name, _last_name)
	and (u.gender = _gender or _gender is null)
	and u."role" = 'user'
	and u.status = 'enabled'
	limit _limit;
end
$$
