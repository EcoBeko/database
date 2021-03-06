drop index resources_entity_id_idx;
drop index users_role_idx;
drop index friends_user_id_idx;
drop index user_chats_user_id_idx;
drop index user_chats_chat_id_idx;
drop index messages_chat_id_idx;
drop index recycling_points_type_idx;
drop index recycling_point_accepts_waste_type_id_idx;
drop index stats_types_maps_stats_type_id_waste_type_id_idx;
drop index stats_records_user_id_idx;
drop index eco_projects_status_idx;
drop index subscriptions_community_id_idx;
drop index subscriptions_user_id_idx;
drop index posts_author_id_idx;
drop index comments_post_id_idx;

drop table comments;
drop table posts;
drop table subscriptions;
drop table communities;
drop table eco_projects;
drop table stats_records;
drop table stats_types_maps;
drop table stats_types;
drop table recycling_point_accepts;
drop table recycling_points;
drop table waste_types;
drop table messages;
drop table user_chats;
drop table chats;
drop table friends;
drop table users;
drop table resources;

drop type gender_enum;
drop type role_enum;
drop type generic_status_enum;
drop type chat_type_enum;
drop type chat_user_type_enum;
drop type resource_type_enum;
drop type recycling_point_type_enum;
drop type eco_project_status_enum;
drop type subscription_status_enum;
drop type post_type_enum;
drop type author_type_enum;