create or replace procedure p_update_eco_projects(_p_id UUID, _status ECO_PROJECT_STATUS_ENUM)
	language plpgsql
as
$$
begin
	update eco_projects 
	set status = _status
	where id = _p_id;
end
$$