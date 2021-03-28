create or replace procedure p_create_recycling_point(
		_title varchar,
		_address varchar,
		_working_time varchar,
		_phone varchar,
		_latitude numeric,
		_longitude numeric,
		_site_url varchar,
		_type RECYCLING_POINT_TYPE_ENUM,
		_additional_info varchar,
		_city varchar,
		inout _id UUID
		)
	language plpgsql
as
$$
declare
	point_id UUID;
	site_id UUID;
begin
	insert into recycling_points (title, address, working_time, phone, latitude, longitude, site, type, additional_info, city)
	values (_title, _address, _working_time, _phone, _latitude, _longitude, null, _type, _additional_info, _city) returning id into point_id;

	if (_site_url is not null) then
		call p_create_resource(_site_url, 'link', point_id, site_id);
	
		update recycling_points 
		set site = site_id
		where id = point_id;
	end if;

	_id = point_id;
end
$$