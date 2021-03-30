CREATE OR REPLACE PROCEDURE public.p_create_resource(
	_path character varying,
	_type resource_type_enum,
	_entity_id uuid,
	INOUT _id uuid)
LANGUAGE 'plpgsql'
AS $BODY$
declare
	resource_id UUID;
begin
	insert into resources ("path", "type", entity_id, "date")
	values (_path, _type, _entity_id, now()) returning id into resource_id;

	_id = resource_id;
end
$BODY$;
