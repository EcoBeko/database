create or replace function f_get_top_waste_types(_threshold int)
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
		wt.id,
		wt.title,
		u.username,
		sum(sr.value) as v_sum
	from waste_types wt
		join stats_records sr on (sr.waste_type_id = wt.id)
		join users u on (sr.user_id = u.id)
	group by wt.id, u.id
	having sum(sr.value) > _threshold
	order by wt.id asc, v_sum desc;
end
$$

