CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "topic_id" integer, "body" text, "total_votes" integer DEFAULT 0, "state" integer DEFAULT 1, "created_at" datetime, "updated_at" datetime, "status_id" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "topics" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "title" varchar(255), "body" text, "state" integer DEFAULT 1, "total_votes" integer DEFAULT 0, "total_views" integer DEFAULT 0, "created_at" datetime, "updated_at" datetime, "total_comments" integer(255) DEFAULT 0, "status_id" integer);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "provider" varchar(255), "index" varchar(255), "uid" varchar(255), "token" varchar(255), "secret" varchar(255), "name" varchar(255), "username" varchar(255), "image" varchar(255), "location" varchar(255), "lang" varchar(255) DEFAULT 'en', "created_at" datetime, "updated_at" datetime, "is_admin" boolean, "state" integer DEFAULT 1, "total_votes" integer DEFAULT 0, "total_topics" integer DEFAULT 0, "total_comments" integer DEFAULT 0);
CREATE TABLE "votes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "voteable_id" integer, "voteable_type" varchar(255), "vote" integer, "created_at" datetime, "updated_at" datetime);
CREATE UNIQUE INDEX "index_comments_on_status_id" ON "comments" ("status_id");
CREATE UNIQUE INDEX "index_topics_on_status_id" ON "topics" ("status_id");
CREATE INDEX "index_users_on_is_admin" ON "users" ("is_admin");
CREATE UNIQUE INDEX "index_votes_on_user_id_and_voteable_type_and_voteable_id" ON "votes" ("user_id", "voteable_type", "voteable_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20101209200315');

INSERT INTO schema_migrations (version) VALUES ('20101210023403');

INSERT INTO schema_migrations (version) VALUES ('20101214120855');

INSERT INTO schema_migrations (version) VALUES ('20101218132534');

INSERT INTO schema_migrations (version) VALUES ('20101218161243');

INSERT INTO schema_migrations (version) VALUES ('20101218133743');

INSERT INTO schema_migrations (version) VALUES ('20101218163749');

INSERT INTO schema_migrations (version) VALUES ('20101222153649');

INSERT INTO schema_migrations (version) VALUES ('20101227135625');

INSERT INTO schema_migrations (version) VALUES ('20101229222658');

INSERT INTO schema_migrations (version) VALUES ('20101230175156');

INSERT INTO schema_migrations (version) VALUES ('20110105125019');