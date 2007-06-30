CREATE TABLE "fun_users" (
  "id" SERIAL NOT NULL,
  "type" varchar(255) NOT NULL,
  "firstname" varchar(50) NOT NULL,
  "lastname" varchar(50) NOT NULL,
  "login" varchar(50) NOT NULL,
  "email" varchar(50) NULL,  
  PRIMARY KEY  ("id")
);

CREATE TABLE "groups" (
  "id" SERIAL NOT NULL,
  "name" varchar(50) NOT NULL UNIQUE,
  "description" varchar(50) default NULL,
  "some_int" integer default NULL,
  "some_float" float default NULL,
  "some_bool" boolean default NULL,
  PRIMARY KEY  ("id")
);

CREATE TABLE "group_memberships" (
  "id" SERIAL,
  "fun_user_id" int NOT NULL,
  "group_id" int NOT NULL,
  PRIMARY KEY  ("id")
);

CREATE TABLE "adjectives" (
  "id" SERIAL,
  "name" varchar(255),
  PRIMARY KEY  ("id")
);

CREATE TABLE "adjectives_fun_users" (
  "fun_user_id" int NOT NULL,
  "adjective_id" int NOT NULL,
  PRIMARY KEY  ("fun_user_id","adjective_id")
);

CREATE TABLE "group_tag" (
  "id" SERIAL NOT NULL,
  "name" varchar(50) NOT NULL,
  "group_id" int NOT NULL,
  "referenced_group_id" int NULL,  
  PRIMARY KEY  ("id")
);

ALTER TABLE "group_tag"
  ADD FOREIGN KEY ("group_id") REFERENCES "groups" ("id") ON DELETE CASCADE;

ALTER TABLE "group_tag"
  ADD FOREIGN KEY ("referenced_group_id") REFERENCES "groups" ("id") ON DELETE CASCADE;  
  
ALTER TABLE "adjectives_fun_users"
  ADD FOREIGN KEY ("adjective_id") REFERENCES "adjectives" ("id") ON DELETE CASCADE;    

