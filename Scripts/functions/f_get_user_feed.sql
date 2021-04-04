create or replace function f_get_user_feed(_user_id UUID)
	returns table (
		id UUID,
		"content" JSONB,
		"date" timestamp,
		"type" POST_TYPE_ENUM,
		author_type AUTHOR_TYPE_ENUM,
		author_id UUID,
		author_avatar varchar,
		author_name varchar
	)
	language plpgsql
as
$$
begin
	return query
	select 
		p.id,
		p."content",
		p."date",
		p."type",
		p.author_type,
		p.author_id,
		f_resolve_post_avatar(p.author_id, p.author_type) as author_avatar,
		f_resolve_post_name(p.author_id, p.author_type) as author_name
	from posts p
	where p.author_id in 
		(
			select friend_id as "id" from friends
			where user_id = _user_id
			union
			select community_id as "id" from subscriptions
			where user_id = _user_id
		)
	or p.author_id = _user_id;
end
$$

create or replace function f_resolve_post_avatar(_id UUID, _type AUTHOR_TYPE_ENUM)
	returns varchar
	language plpgsql
as
$$
declare
	_result varchar;
	image_id UUID;
begin
	if _type = 'user' then
		select u.avatar into image_id from users u
		where u.id = _id;
	else
		select c.main_image into image_id from communities c
		where c.id = _id;
	end if;

	select r."path" into _result from resources as r where r.id = image_id;

	return _result;
end
$$

create or replace function f_resolve_post_name(_id UUID, _type AUTHOR_TYPE_ENUM)
	returns varchar
	language plpgsql
as
$$
declare
	_result varchar;
begin
	if _type = 'user' then
		select u.first_name || ' ' || u.last_name into _result from users u
		where u.id = _id;
	else
		select c.title into _result from communities c
		where c.id = _id;
	end if;

	return _result;
end
$$
