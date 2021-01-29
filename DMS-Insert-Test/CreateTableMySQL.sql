create database testDB;

CREATE TABLE `tblColumns` (
   `seq` int(11) NOT NULL AUTO_INCREMENT,
   `tblName` varchar(64) DEFAULT NULL,
   `columnName` varchar(64) DEFAULT NULL,
   `dataType` varchar(64) DEFAULT NULL,
   PRIMARY KEY (`seq`)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1;