create or replace function f_get_user_chats(_user_id UUID)
	returns table(
		id UUID, 
		title varchar, 
		type CHAT_TYPE_ENUM, 
		user_type CHAT_USER_TYPE_ENUM, 
		last_message varchar)
	language plpgsql
as
$$
declare
begin
	return query
	select 
		c.id, 
		c.title, 
		c.type, 
		uc.user_type,
		(select message from messages m order by "date" desc limit 1) as "last_message"
	from user_chats uc join chats c on uc.chat_id = c.id;
end
$$
