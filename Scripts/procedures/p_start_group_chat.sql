create or replace procedure p_start_group_chat(_admin_id UUID, _title varchar, _participants varchar[])
	language plpgsql
as 
$$
declare
	chat_id UUID;
	_id varchar;
begin
	insert into chats (title, "type")
	values (_title, 'group') returning id into chat_id;

	insert into user_chats (user_id, chat_id, user_type)
	values (_admin_id, chat_id, 'admin');

	foreach _id in array _participants loop
		insert into user_chats (_id, chat_id, user_type)
		values (_user_id, chat_id, 'participant');
	end loop;
end
$$
