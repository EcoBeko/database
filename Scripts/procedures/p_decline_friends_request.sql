create or replace procedure p_decline_friends_request(_id UUID)
	language plpgsql
as
$$
declare
begin
	delete from friends
	where id = _id
	and status = 'created';
end
$$