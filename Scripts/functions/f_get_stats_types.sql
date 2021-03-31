create or replace function f_get_stats_types()
	returns table (
		id UUID,
		title varchar,
		postfix varchar,
		icon varchar
	)
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
		(select r."path" from resources as r where r.id = st.icon) as icon
	from stats_types st;
end
$$
