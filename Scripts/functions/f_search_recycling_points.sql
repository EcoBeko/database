create or replace function f_search_recycling_points(_city varchar, _type RECYCLING_POINT_TYPE_ENUM, _accepts UUID[])
	returns table (
		id UUID,
		title varchar,
		address varchar,
		working_time varchar,
		phone varchar,
		latitude numeric,
		longitude numeric,
		site varchar,
		"type" RECYCLING_POINT_TYPE_ENUM,
		additional_info varchar,
		city varchar
	)
	language plpgsql
as
$$
declare
begin
	return query
	select
		rp.id,
		rp.title,
		rp.address,
		rp.working_time,
		rp.phone,
		rp.latitude,
		rp.longitude,
		(select r."path" from resources r where r.id = rp.site) as site,
		rp."type",
		rp.additional_info,
		rp.city
	from recycling_points rp
	where rp."type" = _type
	and rp.city  = _city
	and (rp.id in 
		(
			select rpa.recycling_point_id from recycling_point_accepts rpa
			where rpa.recycling_point_id = rp.id
			and rpa.waste_type_id = any(_accepts)
		) or cardinality(_accepts) = 0);
end
$$

select * from f_search_recycling_points('almaty', 'recycling', '{}') 

select * from recycling_points rp 
where rp."type" = 'recycling'