create or replace function f_get_waste_types()
	returns table (id UUID, title varchar, icon varchar)
	language plpgsql
as
$$
declare
begin
	return query
	select 
		wt.id, 
		wt.title, 
		(select r.path from resources r where r.id = wt.icon) as icon 
	from waste_types wt;
end
$$
