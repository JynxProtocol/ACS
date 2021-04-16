<html>



<body>



<?php

include '../s_config.php';

$db = mysql_connect($dbhost, $dbuser, $dbpass) or die ('ERROR: CANNOT CONNECT TO DATABASE.');

mysql_select_db($dbname) or die('ERROR: CANNOT SELECT DATABASE.');






if ($id) {



  // query the DB



  $sql = "SELECT * FROM $dbtable WHERE id=$id";



  $result = mysql_query($sql);



  $myrow = mysql_fetch_array($result);



 ?>







  <form method="post" action="<?php echo $PHP_SELF?>">



  <input type=hidden name="id" value="<?php echo $myrow["id"]&nbsp;?>">



  Region:<input type="Text" name="Region" value="<?php echo $myrow["Region"]&nbsp;?>"><br>



  Base:<input type="Text" name="Base" value="<?php echo $myrow["Base"]&nbsp;?>"><br>



  MCap:<input type="Text" name="MCap" value="<?php echo $myrow["MCap"]&nbsp;?>"><br>



  ACap:<input type="Text" name="ACap" value="<?php echo $myrow["Acap"]&nbsp;?>"><br>



  <input type="Submit" name="submit" value="Enter information">



  </form>







  <?php







} else {



  // display list of employees



  $result = mysql_query("SELECT * FROM $dbtable",$db);



  while ($myrow = mysql_fetch_array($result)) {



    printf("<a href="%s?id=%s">%s %s</a><br>n", $PHP_SELF, $myrow["id"], $myrow["Region"], $myrow["Base"]);;



  }



}







?>







</body>



</html>

