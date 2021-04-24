create or replace function f_get_eco_projects()
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
	from eco_projects ep;
end
$$
