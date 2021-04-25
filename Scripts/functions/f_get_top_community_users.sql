create or replace function f_get_top_community_users(_threshold int)
	returns table (
		id UUID,
		title varchar,
		username varchar,
		v_sum int
	)
	language plpgsql
as
$$
begin
	return query
	select
		c.id,
		c.title,
		u.username,
		sum(sr.value) as "v_sum"
	from communities c 
		join subscriptions s on (c.id = s.community_id)
		join users u on (s.user_id = u.id)
		join stats_records sr on (sr.user_id = u.id)
	group by c.id, u.username
	having sum(sr.value) > _threshold
	order by c.title asc, v_sum desc;
end
$$
