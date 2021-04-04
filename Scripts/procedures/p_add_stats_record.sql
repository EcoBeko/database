create or replace procedure p_add_stats_record(_user_id UUID, _waste_type_id UUID, _amount numeric)
	language plpgsql
as
$$
begin
	insert into stats_records (user_id, waste_type_id, "date", value)
	values (_user_id, _waste_type_id, now(), _amount);
end
$$

