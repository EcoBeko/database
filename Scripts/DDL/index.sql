-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Enum
create type gender_enum as enum ('male', 'female');
create type role_enum as enum ('user', 'admin', 'moderator');
create type generic_status_enum as enum ('enabled', 'disabled');
create type chat_type_enum as enum ('user', 'group');
create type chat_user_type_enum as enum ('participant', 'admin');
create type resource_type_enum as enum ('image', 'link');
create type recycling_point_type_enum as enum ('recycling', 'utilization');
create type eco_project_status_enum as enum ('announced', 'ongoing', 'updated', 'finished');
create type subscription_status_enum as enum ('moderator', 'enabled', 'disabled');
create type post_type_enum as enum ('article', 'post');
create type author_type_enum as enum ('user', 'community');

-- Tables
-- Global
create table resources (
  id UUID default uuid_generate_v4(),
  path VARCHAR not null,
  type RESOURCE_TYPE_ENUM not null,
  entity_id UUID not null,
  date TIMESTAMP not null,
  PRIMARY KEY(id)
);

-- Users
create table users (
  id UUID default uuid_generate_v4(),
  first_name VARCHAR,
  last_name VARCHAR,
  username VARCHAR not null unique,
  password VARCHAR not null,
  gender GENDER_ENUM,
  avatar UUID,
  role ROLE_ENUM not null,
  status GENERIC_STATUS_ENUM not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources FOREIGN KEY(avatar) REFERENCES resources(id)
);

create table friends (
  id UUID default uuid_generate_v4(),
  user_id UUID not null,
  friend_id UUID not null,
  date DATE not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_users_user FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT fk_users_friend FOREIGN KEY(friend_id) REFERENCES users(id)
);

-- Chatting
create table chats (
  id UUID default uuid_generate_v4(),
  title VARCHAR,
  type CHAT_TYPE_ENUM not null,
  PRIMARY KEY(id)
);

create table user_chats (
  id UUID default uuid_generate_v4(),
  user_id UUID not null,
  chat_id UUID not null,
  user_type CHAT_USER_TYPE_ENUM not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT fk_chats FOREIGN KEY(chat_id) REFERENCES chats(id)
);

create table messages (
  id UUID default uuid_generate_v4(),
  message VARCHAR not null,
  date TIMESTAMP not null,
  user_id UUID not null,
  chat_id UUID not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT fk_chats FOREIGN KEY(chat_id) REFERENCES chats(id)
);

-- Recycling points
create table waste_types (
  id UUID default uuid_generate_v4(),
  title VARCHAR not null,
  icon UUID not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources FOREIGN KEY(icon) REFERENCES resources(id)
);

create table recycling_points (
  id UUID default uuid_generate_v4(),
  title VARCHAR not null,
  working_time VARCHAR,
  phone VARCHAR not null,
  latitude NUMERIC not null,
  longitude NUMERIC not null,
  site UUID,
  type RECYCLING_POINT_TYPE_ENUM not null,
  additional_info VARCHAR,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources FOREIGN KEY(site) REFERENCES resources(id)
);

create table recycling_point_accepts (
  id UUID default uuid_generate_v4(),
  waste_type_id UUID not null,
  recycling_point_id UUID not null,
  price DECIMAL,
  PRIMARY KEY(id),
  CONSTRAINT fk_recycling_points FOREIGN KEY(recycling_point_id) REFERENCES recycling_points(id),
  CONSTRAINT fk_waste_types FOREIGN KEY(waste_type_id) REFERENCES waste_types(id)
);

-- Statistics
create table stats_types (
  id UUID default uuid_generate_v4(),
  title VARCHAR not null,
  postfix VARCHAR not null,
  icon UUID not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources FOREIGN KEY(icon) REFERENCES resources(id)
);

create table stats_types_maps (
  id UUID default uuid_generate_v4(),
  stats_type_id UUID not null,
  waste_type_id UUID not null,
  coefficient NUMERIC not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_stats_types FOREIGN KEY(stats_type_id) REFERENCES stats_types(id),
  CONSTRAINT fk_waste_types FOREIGN KEY(waste_type_id) REFERENCES waste_types(id)
);

create table stats_records (
  id UUID default uuid_generate_v4(),
  user_id UUID not null,
  waste_type_id UUID not null,
  date TIMESTAMP not null,
  value NUMERIC not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT fk_waste_types FOREIGN KEY(waste_type_id) REFERENCES waste_types(id)
);

-- Eco Projects
create table eco_projects (
  id UUID default uuid_generate_v4(),
  title VARCHAR not null,
  description VARCHAR not null,
  main_image UUID not null,
  link UUID not null,
  date DATE not null,
  status ECO_PROJECT_STATUS_ENUM not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources_image FOREIGN KEY(main_image) REFERENCES resources(id),
  CONSTRAINT fk_resources_link FOREIGN KEY(link) REFERENCES resources(id)
);

-- Communities
create table communities (
  id UUID default uuid_generate_v4(),
  title VARCHAR not null,
  main_image UUID not null,
  description VARCHAR not null,
  admin_id UUID not null,
  status GENERIC_STATUS_ENUM not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_resources FOREIGN KEY(main_image) REFERENCES resources(id),
  CONSTRAINT fk_users FOREIGN KEY(admin_id) REFERENCES users(id)
);

create table subscriptions (
  id UUID default uuid_generate_v4(),
  community_id UUID not null,
  user_id UUID not null,
  status SUBSCRIPTION_STATUS_ENUM not null,
  PRIMARY KEY(id),
  CONSTRAINT fk_communities FOREIGN KEY(community_id) REFERENCES communities(id),
  CONSTRAINT fk_users FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Posts/Articles
create table posts (
  id UUID default uuid_generate_v4(),
  content JSONB not null,
  date TIMESTAMP not null,
  type POST_TYPE_ENUM not null,
  author_type AUTHOR_TYPE_ENUM not null,
  author_id UUID not null,
  PRIMARY KEY(id)
);

create table comments (
  id UUID default uuid_generate_v4(),
  post_id UUID not null,
  message VARCHAR not null,
  date TIMESTAMP not null,
  author_type AUTHOR_TYPE_ENUM not null,
  author_id UUID not null,
  PRIMARY KEY(id)
);

-- Indexes
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
