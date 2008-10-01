-- options 
INSERT INTO whomwah_new.wp_options (option_id, blog_id, option_name, option_value, autoload) 
  SELECT option_id, blog_id, option_name, option_value, autoload FROM whomwah_old.wp_options;
-- delete a bunch of options that appear wrong
DELETE FROM whomwah_new.wp_options WHERE option_name = 'syntaxOptions';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'rewrite_rules';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'sidebars_widgets';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'igsh_options';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'active_plugins';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'recently_edited';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'template';
DELETE FROM whomwah_new.wp_options WHERE option_name = 'stylesheet';
DELETE FROM whomwah_new.wp_options WHERE option_name LIKE 'widget_%';
DELETE FROM whomwah_new.wp_options WHERE option_name LIKE 'rss_%';
-- update db_version
UPDATE whomwah_new.wp_options SET option_value = 'http://localhost/~duncan/wordpress' WHERE option_name = 'siteurl';
UPDATE whomwah_new.wp_options SET option_value = '8201' WHERE option_name = 'db_version';
UPDATE whomwah_new.wp_options SET option_value = 'a:1:{s:13:"array_version";i:3;}' WHERE option_name = 'sidebars_widgets';
UPDATE whomwah_new.wp_options SET option_value = 'WordPress Default' WHERE option_name = 'current_theme';
UPDATE whomwah_new.wp_options SET option_value = 'a:5:{s:13:"administrator";a:2:{s:4:"name";s:23:"Administrator|User role";s:12:"capabilities";a:51:{s:13:"switch_themes";b:1;s:11:"edit_themes";b:1;s:16:"activate_plugins";b:1;s:12:"edit_plugins";b:1;s:10:"edit_users";b:1;s:10:"edit_files";b:1;s:14:"manage_options";b:1;s:17:"moderate_comments";b:1;s:17:"manage_categories";b:1;s:12:"manage_links";b:1;s:12:"upload_files";b:1;s:6:"import";b:1;s:15:"unfiltered_html";b:1;s:10:"edit_posts";b:1;s:17:"edit_others_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:10:"edit_pages";b:1;s:4:"read";b:1;s:8:"level_10";b:1;s:7:"level_9";b:1;s:7:"level_8";b:1;s:7:"level_7";b:1;s:7:"level_6";b:1;s:7:"level_5";b:1;s:7:"level_4";b:1;s:7:"level_3";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:17:"edit_others_pages";b:1;s:20:"edit_published_pages";b:1;s:13:"publish_pages";b:1;s:12:"delete_pages";b:1;s:19:"delete_others_pages";b:1;s:22:"delete_published_pages";b:1;s:12:"delete_posts";b:1;s:19:"delete_others_posts";b:1;s:22:"delete_published_posts";b:1;s:20:"delete_private_posts";b:1;s:18:"edit_private_posts";b:1;s:18:"read_private_posts";b:1;s:20:"delete_private_pages";b:1;s:18:"edit_private_pages";b:1;s:18:"read_private_pages";b:1;s:12:"delete_users";b:1;s:12:"create_users";b:1;s:17:"unfiltered_upload";b:1;s:14:"edit_dashboard";b:1;s:14:"update_plugins";b:1;s:14:"delete_plugins";b:1;}}s:6:"editor";a:2:{s:4:"name";s:16:"Editor|User role";s:12:"capabilities";a:34:{s:17:"moderate_comments";b:1;s:17:"manage_categories";b:1;s:12:"manage_links";b:1;s:12:"upload_files";b:1;s:15:"unfiltered_html";b:1;s:10:"edit_posts";b:1;s:17:"edit_others_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:10:"edit_pages";b:1;s:4:"read";b:1;s:7:"level_7";b:1;s:7:"level_6";b:1;s:7:"level_5";b:1;s:7:"level_4";b:1;s:7:"level_3";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:17:"edit_others_pages";b:1;s:20:"edit_published_pages";b:1;s:13:"publish_pages";b:1;s:12:"delete_pages";b:1;s:19:"delete_others_pages";b:1;s:22:"delete_published_pages";b:1;s:12:"delete_posts";b:1;s:19:"delete_others_posts";b:1;s:22:"delete_published_posts";b:1;s:20:"delete_private_posts";b:1;s:18:"edit_private_posts";b:1;s:18:"read_private_posts";b:1;s:20:"delete_private_pages";b:1;s:18:"edit_private_pages";b:1;s:18:"read_private_pages";b:1;}}s:6:"author";a:2:{s:4:"name";s:16:"Author|User role";s:12:"capabilities";a:10:{s:12:"upload_files";b:1;s:10:"edit_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:4:"read";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:12:"delete_posts";b:1;s:22:"delete_published_posts";b:1;}}s:11:"contributor";a:2:{s:4:"name";s:21:"Contributor|User role";s:12:"capabilities";a:5:{s:10:"edit_posts";b:1;s:4:"read";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:12:"delete_posts";b:1;}}s:10:"subscriber";a:2:{s:4:"name";s:20:"Subscriber|User role";s:12:"capabilities";a:2:{s:4:"read";b:1;s:7:"level_0";b:1;}}}' WHERE option_name = 'wp_user_roles';

-- comments
INSERT INTO whomwah_new.wp_comments 
  SELECT * FROM whomwah_old.wp_comments;

-- posts
INSERT INTO whomwah_new.wp_posts 
  SELECT * FROM whomwah_old.wp_posts;
-- This columns seem missing or set wrong in 2.02
UPDATE whomwah_new.wp_posts SET post_type = 'post'
  WHERE menu_order != 999;
UPDATE whomwah_new.wp_posts SET post_type = 'page', post_status = 'pending', menu_order = 0
  WHERE menu_order = 999;
-- set the guid for all posts and pages to be consistent as they have got out of sync
UPDATE whomwah_new.wp_posts SET guid = CONCAT('http://whomwah.com/?p=' ,ID) WHERE post_type = 'post';
UPDATE whomwah_new.wp_posts SET guid = CONCAT('http://whomwah.com/?page_id=' ,ID) WHERE post_type = 'page';

-- post meta
--INSERT INTO whomwah_new.wp_postmeta 
-- SELECT * FROM whomwah_old.wp_postmeta;

-- users 
INSERT INTO whomwah_new.wp_users 
  SELECT * FROM whomwah_old.wp_users;

-- user meta 
INSERT INTO whomwah_new.wp_usermeta 
  SELECT * FROM whomwah_old.wp_usermeta;

-- terms ( first add the terms )
INSERT INTO whomwah_new.wp_terms (term_id, name, slug, term_group)
  SELECT cat_ID, cat_name, category_nicename, 0 
  FROM whomwah_old.wp_categories;
-- terms ( add the terms taxonomy )
INSERT INTO whomwah_new.wp_term_taxonomy (term_taxonomy_id, term_id, taxonomy, description, parent, count)
  SELECT cat_ID, cat_ID, 'category', category_description, category_parent, category_count 
  FROM whomwah_old.wp_categories;
-- terms ( add the join from post to term )  
INSERT INTO whomwah_new.wp_term_relationships (object_id, term_taxonomy_id, term_order)
  SELECT post_id, category_id, 0 
  FROM whomwah_old.wp_post2cat;

-- set up some temp data to add linkcategories
CREATE TEMPORARY TABLE temp_links_table 
  SELECT l.*, lc.cat_name, REPLACE(LCASE(lc.cat_name), ' ', '') AS cat_slug
  FROM whomwah_old.wp_links l 
  INNER JOIN whomwah_old.wp_linkcategories lc ON l.link_category=lc.cat_id;

-- links 
INSERT INTO whomwah_new.wp_links 
  SELECT * FROM whomwah_old.wp_links;

-- link categories
SET @max_term_id = (
  SELECT MAX(term_id) 
  FROM whomwah_new.wp_terms );
INSERT INTO whomwah_new.wp_terms (term_id, name, slug, term_group)
  SELECT @max_term_id + link_id, cat_name, cat_slug, 0 
  FROM temp_links_table 
  GROUP BY cat_slug ASC;

-- link taxonomy
INSERT INTO whomwah_new.wp_term_taxonomy (term_taxonomy_id, term_id, taxonomy)
  SELECT @max_term_id + link_id, @max_term_id + link_id, 'link_category' 
  FROM temp_links_table 
  GROUP BY cat_slug ASC;

-- link term join
INSERT INTO whomwah_new.wp_term_relationships (object_id, term_taxonomy_id, term_order)
  SELECT link_id, @max_term_id + link_id, 0 
  FROM temp_links_table; 
