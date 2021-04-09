create or replace procedure p_update_sub_status(_user_id UUID, _community_id UUID, _status SUBSCRIPTION_STATUS_ENUM)
	language plpgsql
as 
$$
begin 
	update subscriptions
	set status = _status
	where community_id = _community_id
	and user_id = _user_id;
end
$$
