create table if not exists halfassed_mail_users(
    `id` int(11) unsigned not null auto_increment primary key,
    `username` varchar(48) not null

    -- TODO: figure out how to implement authentication
);

create table if not exists halfassed_mail_emails(
    `id` int(11) unsigned not null auto_increment primary key,
    `content` longtext not null,
    `user_id` int(11) not null,  -- User id who owns the email

    key `user_id` (`user_id`),
    constraint `halfassed_mail_emails_constraint_1` foreign key (`user_id`) references `halfassed_mail_users` (`id`) on delete cascade
);
