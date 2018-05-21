# Mostly from https://github.com/edx/devstack/blob/9a97d85643efe0237c42b12aea62f2b6a68ddced/provision.sql

CREATE DATABASE IF NOT EXISTS edxapp;
CREATE DATABASE IF NOT EXISTS edxapp_csmh;
GRANT ALL ON edxapp.* TO 'edxapp001'@'%' IDENTIFIED BY 'password';
GRANT ALL ON edxapp_csmh.* TO 'edxapp001'@'%';
FLUSH PRIVILEGES;
