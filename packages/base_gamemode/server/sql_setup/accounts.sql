CREATE TABLE IF NOT EXISTS accounts (
    steamid int primary key,
    admin smallint default 0,
    playtime int default 0,
    cash int default 0,
    score int default 0,
    kills int default 0,
    deaths int default 0,
    joindate int default UNIX_TIMESTAMP(),
    lastseen int default UNIX_TIMESTAMP(),
    join_ip varchar(16),
    lastseen_ip varchar(16)
);
CREATE TABLE IF NOT EXISTS kicks (
    targetid int,
    adminid int,
    reason varchar(128)
);
CREATE TABLE IF NOT EXISTS bans (
    targetid int,
    adminid int,
    reason varchar(128),
    lifted boolean default false
);
CREATE TABLE IF NOT EXISTS unbans (
    targetid int,
    adminid int,
    reason varchar(128)
);
CREATE TABLE IF NOT EXISTS warns (
    targetid int,
    adminid int,
    reason varchar(128)
);