create or replace function f_get_user_by_id(_id UUID)
	returns table (
		id UUID,
		first_name varchar,
		last_name varchar,
		username varchar,
		"password" varchar,
		gender GENDER_ENUM,
		avatar varchar,
		"role" ROLE_ENUM,
		status GENERIC_STATUS_ENUM
	)
	language plpgsql
as
$$
declare
begin
	return query
	select 
		u.id, 
		u.first_name, 
		u.last_name,
		u.username,
		u."password",
		u.gender,
		(select r."path" from resources as r where r.id = u.avatar) as avatar,
		u."role",
		u.status
	from users u
	where u.id = _id
	and u.status = 'enabled';
end
$$
