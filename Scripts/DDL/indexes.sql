create index resources_entity_id_idx on resources(entity_id, id)
where type = 'link';

create index users_role_idx on users(role, id)
where status = 'disabled';

create index friends_user_id_idx on friends(user_id);

create index user_chats_user_id_idx on user_chats(user_id);
create index user_chats_chat_id_idx on user_chats(chat_id);

create index messages_chat_id_idx on messages(chat_id);

create index recycling_points_type_idx on recycling_points(type);

create index recycling_point_accepts_waste_type_id_idx on recycling_point_accepts(waste_type_id);

create index stats_types_maps_stats_type_id_waste_type_id_idx on stats_types_maps(stats_type_id, waste_type_id);

create index stats_records_user_id_idx on stats_records(user_id);

create index eco_projects_status_idx on eco_projects(status);

create index subscriptions_community_id_idx on subscriptions(community_id);
create index subscriptions_user_id_idx on subscriptions(user_id);

create index posts_author_id_idx on posts(author_id);

create index comments_post_id_idx on comments(post_id);