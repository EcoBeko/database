create or replace procedure p_subscribe_user(_user_id UUID, _community_id UUID)
	language plpgsql
as
$$
begin 
	insert into subscriptions (user_id, community_id, status)
	values (_user_id, _community_id, 'enabled');
end
$$
