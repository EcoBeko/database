create or replace procedure p_create_waste_type(_title varchar, _icon_path varchar)
	language plpgsql
as
$$
declare
	item_id UUID;
	icon_id UUID;
begin
	insert into waste_types (title, icon)
	values (_title, null) returning id into item_id;

	call p_create_resource(_icon_path, 'image', item_id, icon_id);

	update waste_types 
	set icon = icon_id
	where id = item_id;
end
$$

