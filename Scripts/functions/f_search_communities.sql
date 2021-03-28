create or replace function f_search_communities(
		_title varchar, 
		_description varchar
		)
	returns setof communities
	language plpgsql
as
$$
begin
	return query
	select * from communities
	where (position(_title in title) not in (0) or _title is null)
	and (position(_description in description) not in (0) or _description is null);
end
$$