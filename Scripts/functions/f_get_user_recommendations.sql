-- getting friends of friends
create or replace function f_get_user_recommendations(_user_id UUID)
	returns table (
		id UUID,
		first_name varchar,
		last_name varchar,
		username varchar,
		avatar varchar
	)
	language plpgsql
as
$$
declare
	_ids UUID[];
begin
	_ids = array(
		select f.friend_id from friends f
		where f.user_id in 
			(
				select f1.friend_id from friends f1
				where f1.user_id = _user_id
			)
		and f.friend_id <> _user_id 
	);

	return query
	select 
		u.id,
		u.first_name,
		u.last_name,
		u.username,
		(select r."path" from resources r where r.id = u.avatar) as avatar
	from users u
	where u."role" = 'user'
		and u.status = 'enabled'
		and u.id = any(_ids)
		or cardinality(_ids) = 0
	order by random()
	limit 5;
end
$$

