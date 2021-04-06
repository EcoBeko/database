create or replace function f_get_friend(_user_id UUID, _friend_id UUID)
	returns table(
		id UUID,
		first_name varchar,
		last_name varchar,
		username varchar,
		gender GENDER_ENUM,
		avatar varchar,
		friend_status FRIEND_STATUS_ENUM
	)
	language plpgsql
as
$$
begin
	return query
	select 
		u.id,
		u.first_name,
		u.last_name,
		u.username,
		u.gender,
		(select r."path" from resources r where r.id = u.avatar),
		(
			select f.status from friends f 
			where f.user_id = _user_id
			and f.friend_id = _friend_id
		) as friend_status
	from users u
	where u."role" = 'user'
	and u.status = 'enabled'
	and u.id = _friend_id;
end
$$