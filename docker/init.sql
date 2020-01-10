DROP DATABASE IF EXISTS test_db;
CREATE DATABASE IF NOT EXISTS test_db;

DROP DATABASE IF EXISTS test_db_test;
CREATE DATABASE IF NOT EXISTS test_db_test;

GRANT ALL ON *.* to test_user@localhost IDENTIFIED BY 'pass';
GRANT ALL ON *.* to test_user@'%' IDENTIFIED BY 'pass';
