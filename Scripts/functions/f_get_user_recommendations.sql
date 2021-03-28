-- getting friends of friends
create or replace function f_get_user_recommendations(_user_id UUID)
	returns setof users
	language plpgsql
as
$$
declare
begin
	return query
	select * from users
	where role = 'user'
	and status = 'enabled'
	and id in 
		(
			select friend_id from friends
			where user_id in 
				(
					select friend_id from friends
					where user_id = _user_id
				)
			and friend_id <> _user_id
		)
	order by random()
	limit 10;
end
$$

