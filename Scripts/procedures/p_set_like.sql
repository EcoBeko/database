create or replace procedure p_set_like(_post_id UUID, _user_id UUID)
	language plpgsql
as
$$
declare
	_contains boolean;
begin
	select _user_id = any(p."content"->>'likes'::UUID[]) into _contains from posts p
	where p.id = _post_id;

	raise notice 'Value %', _contains;
end
$$

