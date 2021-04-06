create or replace procedure p_update_friend_status(_user_id UUID, _friend_id UUID, _status varchar)
	language plpgsql
as
$$
begin
	if _status = 'send' then
		insert into friends (user_id, friend_id, "date", status)
		values
			(_user_id, _friend_id, now(), 'created'),
			(_friend_id, _user_id, now(), 'created');	
	elsif _status = 'remove' then
		delete from friends
		where 
			(user_id = _user_id and friend_id = _friend_id)
			or
			(user_id = _friend_id and friend_id = _user_id);
	elsif _status = 'accept' then
		update friends
		set status = 'accepted'
		where 
			(user_id = _user_id and friend_id = _friend_id)
			or
			(user_id = _friend_id and friend_id = _user_id);
	end if;
end
$$
