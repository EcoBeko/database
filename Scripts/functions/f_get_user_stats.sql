create or replace function f_get_user_stats(_user_id UUID)
	returns table (id UUID, title varchar, postfix varchar, icon varchar, sum numeric)
	language plpgsql
as
$$
declare
begin
	return query
	select 
		st.id, 
		st.title, 
		st.postfix, 
		(select r.path from resources r where r.id = st.icon) as icon, 
		sum(sr.value * stm.coefficient) 
	from stats_types st 
		join stats_types_maps stm on st.id = stm.stats_type_id 
		join stats_records sr on stm.waste_type_id = sr.waste_type_id
	where sr.user_id = _user_id
	group by st.id;
end
$$
