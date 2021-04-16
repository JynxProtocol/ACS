<?php
include '../s_config.php';

$con = mysql_connect($dbhost, $dbuser, $dbpass) or die ('ERROR: CANNOT CONNECT TO DATABASE.');

mysql_select_db($dbname) or die('ERROR: CANNOT SELECT DATABASE.');

$sql="INSERT INTO $dbtable (Region, Base, SMax)
VALUES
('$_POST[Region]','$_POST[Base]','$_POST[SMax]')";

if (!mysql_query($sql,$con))
  {
  die('Error: ' . mysql_error());
  }
echo "1 record added";

mysql_close($con)
?>