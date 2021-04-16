<?php
include '../s_config.php';

$con = mysql_connect($dbhost, $dbuser, $dbpass) or die ('ERROR: CANNOT CONNECT TO DATABASE.');

mysql_select_db($dbname) or die('ERROR: CANNOT SELECT DATABASE.');


$result = mysql_query("SELECT * FROM $dbtable");

echo "<table border='1'>
<tr>
<th>Region</th>
<th>Base</th>
<th>SMax</th>
</tr>";

while($row = mysql_fetch_array($result))
  {
  echo "<tr>";
  echo "<td>" . $row['Region'] . "</td>";
  echo "<td>" . $row['Base'] . "</td>";
  echo "<td>" . $row['SMax'] . "</td>";
  echo "</tr>";
  }
echo "</table>";

mysql_close($con);
?>