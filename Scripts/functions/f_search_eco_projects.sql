create or replace function f_search_eco_projects(_title varchar, _status ECO_PROJECT_STATUS_ENUM)
	returns table (
		id UUID,
		title varchar,
		description varchar,
		main_image varchar,
		link varchar,
		"date" date,
		status ECO_PROJECT_STATUS_ENUM
	)
	language plpgsql
as
$$
declare
begin
	return query
	select
		ep.id,
		ep.title,
		ep.description,
		(select r."path" from resources as r where r.id = ep.main_image) as main_image,
		(select r."path" from resources as r where r.id = ep.link) as link,
		ep."date",
		ep.status
	from eco_projects ep
	where (position(_title in ep.title) not in (0) or _title is null)
	and (ep.status = _status or _status is null);
end
$$