CREATE TABLE `networks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `tagline` varchar(255) default NULL,
  `current_show` text,
  `current_title` varchar(255) default NULL,
  `current_start` datetime default NULL,
  `current_duration` int(11) default NULL,
  `next_show` text,
  `next_title` varchar(255) default NULL,
  `next_start` datetime default NULL,
  `next_duration` int(11) default NULL,
  `base_name` varchar(255) default NULL,
  `channelid` varchar(255) default NULL,
  `is_national` tinyint(1) default '1',
  `url` varchar(255) default NULL,
  `ram` varchar(255) default NULL,
  `asx` varchar(255) default NULL,
  `bbc` varchar(255) default NULL,
  `position` int(11) default '0',
  `active` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1;

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `network_id` int(11) default NULL,
  `clicks` int(11) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_played` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_preferences_on_user_id` (`user_id`),
  KEY `index_preferences_on_network_id` (`network_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39632 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `fbid` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `sex` varchar(255) default NULL,
  `timezone` varchar(255) default NULL,
  `stream_type` varchar(255) default NULL,
  `total_plays` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8995 DEFAULT CHARSET=latin1;

INSERT INTO schema_info (version) VALUES (25)