CREATE TABLE `fun_users` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `login` varchar(50) NOT NULL,
  `email` varchar(50) NULL,  
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL UNIQUE,
  `description` varchar(50) default NULL,
  `some_int` integer default NULL,
  `some_float` float default NULL,
  `some_bool` boolean default NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `group_memberships` (
  `id` int(11) NOT NULL auto_increment,
  `fun_user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `adjectives` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255),
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

CREATE TABLE `adjectives_fun_users` (
  `fun_user_id` int(11) NOT NULL,
  `adjective_id` int(11) NOT NULL,
  PRIMARY KEY  (`fun_user_id`,`adjective_id`)
) TYPE=InnoDB;


CREATE TABLE `group_tag` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `group_id` int(11) NOT NULL,
  `referenced_group_id` int(11) NULL,  
  PRIMARY KEY  (`id`)
) TYPE=InnoDB;

ALTER TABLE `group_tag`
  ADD FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE;

ALTER TABLE `group_tag`
  ADD FOREIGN KEY (`referenced_group_id`) REFERENCES `groups` (`id`) ON DELETE CASCADE;

ALTER TABLE `adjectives_fun_users`
  ADD FOREIGN KEY (`adjective_id`) REFERENCES `adjectives` (`id`) ON DELETE CASCADE;    


