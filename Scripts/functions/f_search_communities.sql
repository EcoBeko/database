create or replace function f_search_communities(
		_title varchar, 
		_description varchar
		)
	returns table (
		id UUID,
		title varchar,
		main_image varchar,
		description varchar,
		admin_id UUID,
		status GENERIC_STATUS_ENUM,
		subscribers bigint
	)
	language plpgsql
as
$$
declare
	_limit int = null;
begin
	if _title is null and _description is null then
		_limit = 1000;
	end if;
	
	return query
	select 
		c.id,
		c.title,
		(select r."path" from resources r where r.id = c.main_image) as main_image,
		c.description,
		c.admin_id,
		c.status,
		(select count(*) from subscriptions s where s.community_id = c.id) as subscribers
	from communities c
	where f_str_search(c.title, _title)
		and f_str_search(c.description, _description)
		and c.status = 'enabled'
	limit _limit;
end
$$
