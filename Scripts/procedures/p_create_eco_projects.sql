create or replace procedure p_create_eco_project(
		_title varchar, 
		_image_path varchar, 
		_description varchar,
		_link varchar,
		inout _id UUID default uuid_nil()
		)
	language plpgsql
as
$$
declare
	p_id UUID;
	image_id UUID;
	link_id UUID;
begin
	insert into eco_projects(title, description, main_image, link, "date", status)
	values (_title, _description, null, null, now(), 'announced') returning id into p_id;

	call p_create_resource('projects/' || p_id || '/' || _image_path, 'image', p_id, image_id);
	call p_create_resource(_link, 'link', p_id, link_id);

	update eco_projects 
	set main_image = image_id, link = link_id
	where id = p_id;

	_id = p_id;
end
$$
