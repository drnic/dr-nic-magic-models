CREATE TABLE `fun_users` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `login` varchar(50) NOT NULL,
  `email` varchar(50) NULL,  
  PRIMARY KEY  (`id`)
);

CREATE TABLE `groups` (
  `id` int(11) NOT NULL ,
  `name` varchar(50) NOT NULL UNIQUE,
  `description` varchar(50) default NULL,
  `some_int` integer default NULL,
  `some_float` float default NULL,
  `some_bool` boolean default NULL,
  PRIMARY KEY  (`id`)
);

CREATE TABLE `group_memberships` (
  `id` int(11) NOT NULL,
  `fun_user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
);

CREATE TABLE `adjectives` (
  `id` int(11) NOT NULL,
  `name` varchar(255),
  PRIMARY KEY  (`id`)
);

CREATE TABLE `adjectives_fun_users` (
  `fun_user_id` int(11) NOT NULL,
  `adjective_id` int(11) NOT NULL,
  PRIMARY KEY  (`fun_user_id`,`adjective_id`)
);


CREATE TABLE `group_tag` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `group_id` int(11) NOT NULL,
  `referenced_group_id` int(11) NULL,  
  PRIMARY KEY  (`id`)
);

  
