create or replace procedure p_create_stats_type(_title varchar, _icon_path varchar, _postfix varchar)
	language plpgsql
as
$$
declare
	item_id UUID;
	icon_id UUID;
begin
	insert into stats_types (title, postfix, icon)
	values (_title, _postfix, null) returning id into item_id;

	call p_create_resource(_icon_path, 'image', item_id, icon_id);

	update stats_types 
	set icon = icon_id
	where id = item_id;
end
$$
