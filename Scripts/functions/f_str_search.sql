create or replace function f_str_search(_target varchar, _substr varchar)
	returns boolean
	language plpgsql
as 
$$
begin
	return (position(lower(_substr) in lower(_target)) not in (0) or _substr is null);
end
$$