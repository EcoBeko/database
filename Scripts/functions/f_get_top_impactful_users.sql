create or replace function f_get_top_impactful_users(_threshold int, _date_begin date, _date_end date)
	returns table (
		id UUID,
		title varchar,
		postfix varchar,
		wt_title varchar,
		username varchar,
		v_sum numeric
	)
	language plpgsql
as
$$
begin
	return query
	select
		st.id,
		st.title,
		st.postfix,
		wt.title as wt_title,
		u.username,
		sum(sr.value) * stm.coefficient as v_sum
	from stats_types st 
		join stats_types_maps stm on (stm.stats_type_id = st.id)
		join waste_types wt on (wt.id = stm.waste_type_id)
		join stats_records sr on (sr.waste_type_id = wt.id)
		join users u on (u.id = sr.user_id)
	where sr."date" between _date_begin and _date_end
	group by st.id, stm.id, wt.id, u.id
	having sum(sr.value) * stm.coefficient > _threshold
	order by st.title, v_sum desc;
end
$$

