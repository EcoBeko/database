create or replace function f_search_recycling_points(_city varchar, _type RECYCLING_POINT_TYPE_ENUM, _accepts UUID[])
	returns setof recycling_points
	language plpgsql
as
$$
declare
begin
	return query
	select * from recycling_points rp
	where "type" = _type
	and city  = _city
	and rp.id in 
		(
			select rpa.recycling_point_id from recycling_point_accepts rpa
			where rpa.recycling_point_id = rp.id
			and rpa.waste_type_id = any(_accepts)
		) or cardinality(_accepts) = 0;
end
$$