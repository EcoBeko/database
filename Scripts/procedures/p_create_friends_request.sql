create or replace procedure p_create_friends_request(_user_id UUID, _friend_id UUID)
	language plpgsql
as
$$
declare
begin
	insert into friends(user_id, friend_id, "date", status)
	values (_user_id, _friend_id, now(), 'created');
end
$$