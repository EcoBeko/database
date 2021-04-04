create or replace procedure p_unlink_resource(_id UUID, _table_name varchar, _table_property varchar)
	language plpgsql
as
$$
declare 
	_table_id UUID;
begin 
	select entity_id into _table_id from resources
	where id = _id;

	update resources 
	set entity_id = uuid_nil()
	where id = _id;

	if _table_name is not null and _table_property is not null then
		execute 'update $1 ' || 'set $2 = null where id = $3'
		using _table_name, _table_property, _table_id;
	end if;

	delete from resources
	where id = _id;
end
$$