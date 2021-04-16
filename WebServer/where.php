<?php
include '../s_config.php';

$con = mysql_connect($dbhost, $dbuser, $dbpass) or die ('ERROR: CANNOT CONNECT TO DATABASE.');

mysql_select_db($dbname) or die('ERROR: CANNOT SELECT DATABASE.');

$result = mysql_query("SELECT * FROM $dbtable
WHERE Region='Avilion Hinterlands'");

while($row = mysql_fetch_array($result))
  {
  echo $row['Region'] . " " . $row['Base'];
  echo "<br />";
  }
?>