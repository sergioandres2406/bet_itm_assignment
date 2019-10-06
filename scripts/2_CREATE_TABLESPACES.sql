

/*Create 3 tablespaces:

Smallfile tablespace with 1Gb of data splited in 2 datafile. The name of the tablespace should be "BET_ITM".
Bigfile tablespace with 2Gb of data. The name of the tablespace should be "BET_AUDITING"
Undo tablespace with 500Mb and 1 datafile. (Set this tablespace to be used in the system)
*/

  
  CREATE SMALLFILE TABLESPACE BET_ITM
  DATAFILE 'E:\ITM\BDAVANZADAS\SMALLBET_ITM1.dbf' SIZE 500M,
           'E:\ITM\BDAVANZADAS\SMALLBET_ITM2.dbf' SIZE 500M;
 
   
  CREATE BIGFILE TABLESPACE BET_AUDITING
  DATAFILE 'E:\ITM\BDAVANZADAS\BET_AUDITING.dbf'   SIZE 2G;
  
  
  CREATE UNDO TABLESPACE   UNDO_TBS datafile 'E:\ITM\BDAVANZADAS\UNDO_TBS.db' size 500M;
  
  