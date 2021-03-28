create or replace procedure p_assign_community_moderator(_community_id UUID, _user_id UUID)
	language plpgsql
as
$$
declare
begin
	update subscriptions 
	set status = 'moderator'
	where community_id = _community_id
	and user_id = _user_id;
end
$$