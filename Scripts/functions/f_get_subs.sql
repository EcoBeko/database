create or replace function f_get_subs(_id UUID)
	returns table (
		id UUID,
		username varchar,
		first_name varchar,
		last_name varchar,
		avatar varchar,
		sub_status SUBSCRIPTION_STATUS_ENUM
	)
	language plpgsql
as
$$
begin
	return query
	select
		u.id,
		u.username,
		u.first_name,
		u.last_name,
		(select r."path" from resources r where r.id = u.avatar) as avatar,
		s.status as sub_status
	from communities c 
		join subscriptions s on (c.id = s.community_id)
		join users u on (s.user_id = u.id)
	where c.id = _id;
end
$$