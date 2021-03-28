create or replace procedure p_start_user_chat(_user_id UUID, _friend_id UUID)
	language plpgsql
as 
$$
declare
	chat_id UUID;
begin
	insert into chats (title, "type")
	values (null, 'user') returning id into chat_id;
	
	insert into user_chats (user_id, chat_id, user_type) values
	(_user_id, chat_id, 'participant'),
	(_friend_id, chat_id, 'participant');
end
$$
