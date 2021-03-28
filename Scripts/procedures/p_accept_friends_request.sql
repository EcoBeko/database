create or replace procedure p_accept_friends_request(_id UUID)
	language plpgsql
as
$$
declare
begin
	update friends
	set status = 'accepted'
	where id = _id
	and status = 'created';
end
$$