create or replace procedure p_set_like(_post_id UUID, _user_id UUID)
	language plpgsql
as
$$
declare
	_contains boolean = false;
begin
	select p."content"->'likes' @> jsonb_build_array(_user_id) into _contains from posts p
	where p.id = _post_id;

	if _contains = true then
		update posts
		set "content" = jsonb_set(
			"content"::jsonb,
			array['likes'],
			("content"->'likes')::jsonb - _user_id::text
		)
		where id = _post_id;
	else
		update posts
		set "content" = jsonb_set(
			"content"::jsonb,
			array['likes'],
			("content"->'likes')::jsonb || jsonb_build_array(_user_id)::jsonb
		) 
		where id = _post_id;
	end if;
end
$$

