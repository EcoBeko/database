create or replace function f_get_user_feed(_user_id UUID)
	returns setof posts
	language plpgsql
as
$$
begin
	return query
	select * from posts
	where author_id in 
		(
			select friend_id as "id" from friends
			where user_id = _user_id
			union
			select community_id as "id" from subscriptions
			where user_id = _user_id
		);
end
$$
