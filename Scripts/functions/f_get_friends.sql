create or replace function f_get_friends(_user_id UUID)
	returns table(
		id UUID, 
		first_name varchar,
		last_name varchar,
		username varchar,
		avatar varchar,
		friend_status FRIEND_STATUS_ENUM,
		first_id UUID
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
		(select r."path" from resources r where r.id = u.avatar) as avatar,
		f.status as "friend_status",
		(
			select f1.user_id from friends f1
			where 
				(f1.user_id = f.user_id and f1.friend_id = f.friend_id)
				or
				(f1.user_id = f.friend_id and f1.friend_id = f.user_id)
			limit 1
		) as first_id
	from friends f join users u on f.friend_id = u.id
	where f.user_id = _user_id
	and u."role" = 'user'
	and u.status = 'enabled';
end
$$
