create or replace function f_get_community(_user_id UUID, _id UUID)
	returns table (
		id UUID,
		title varchar,
		description varchar,
		main_image varchar,
		admin_id UUID,
		subscribers int,
		is_moderator boolean,
		is_subscribed boolean
	)
	language plpgsql
as
$$
begin
	return query
	select 
		c.id,
		c.title,
		c.description,
		(select r."path" from resources r where r.id = c.main_image) as main_image,
		c.admin_id,
		(select count(*)::int from subscriptions s where s.community_id = _id) as subscribers,
		(
			select count(*) = 1 from subscriptions s 
			where s.community_id = _id
				and s.user_id = _user_id
				and s.status = 'moderator'
		) as is_moderator,
		(
			select count(*) = 1 from subscriptions s 
			where s.community_id = _id
				and s.user_id = _user_id
		)
	from communities c
	where c.id = _id;
end
$$

