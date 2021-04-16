<?php
include 's_config.php';

mysql_connect($dbhost, $dbuser, $dbpass) or die ('ERROR: CANNOT CONNECT TO DATABASE.');
mysql_select_db($dbname) or die('ERROR: CANNOT SELECT DATABASE.');

//collect the data sent in the post
$column = $_REQUEST['column'];
$key = $_REQUEST['key'];
$action = $_REQUEST['action'];
$values=$_REQUEST['values'];
$operators=$_REQUEST['operators'];
$password =$_REQUEST['password'];

if($password!=$secret){
    echo "Authentication Failed.";
    return;
}
switch($action){
    case 'retrieve':
        retrieve_data($dbtable, $key, $column);
        break;
    case 'input':
        input_data($dbtable, $key, $column, $values);
        break;
    case 'delete':
        delete_data($dbtable, $key, $column);
        break;
    case 'query':
        query_data($dbtable, $column, $key, $operators, $values);
		break;
}

function retrieve_data($table, $varkey, $data){
    $sql = "SELECT ".$data." FROM $table WHERE Region= '$varkey'";
    $result = mysql_query($sql) or die("ERROR: SYNTAX");
    $data = explode(',',$data);
    while($row = mysql_fetch_array($result))
    {
        if(empty($row)){
            return;
        }
        if(count($data) >1){
            $i=0;
            foreach($data as $d){
                echo $row[$i];
                if($i<count($data)-1){
                    echo ",";
                }
                $i++;                            
            }
            //echo "\n";
        }
        else{
            echo $row[$data[0]];
            //echo "\n";
        }
    }
}

function input_data($table, $varkey, $data, $value){
    $data=explode(',',$data);
    $value=explode(',',$value);
    $i=0;
    
    $r=mysql_query("SELECT * FROM $table WHERE uuid= '$varkey'");
    if(mysql_num_rows($r)==0){
        $sql ="INSERT INTO $table (uuid, ".implode(",",$data).") VALUES ('$varkey','".str_replace("',' ", "','",implode("','",$value))."')";
        $result = mysql_query($sql) or die("ERROR: SYNTAX");
    }
    else {
        foreach($data as $d){
            $sql="UPDATE $table SET ".$data[$i]." = '".$value[$i]."' WHERE uuid= '$varkey'";
            $result = mysql_query($sql) or die("ERROR: SYNTAX");
            $i++;
        }        
    }
}

function delete_data($table, $varkey){
    $sql = "DELETE FROM $table WHERE Region= '$varkey'";
    $result = mysql_query($sql) or die("ERROR: SYNTAX");
    echo "SUCESS: Deleted data";
}

function query_data($table, $retrieve, $param, $op, $val){
    $v="";
    $i=0;    
    $param=explode(',',$param);
    $op=explode(',',$op);
    $val=explode(',',$val);
    foreach($param as $p){
        if($i>0){
            $v=$v." AND";
        }
        $v=$v." ".$param[$i]." ".$op[$i]." '".trim($val[$i])."'";
        $i++;
    }
    $sql= "SELECT $retrieve FROM $table WHERE".$v;
    $result = mysql_query($sql) or die("ERROR: SYNTAX");
    $retrieve=explode(',',$retrieve);
    $k=0;
    while($row = mysql_fetch_array($result))
    {
        if($k>0){
            echo "^";
        }
        if(empty($row)){
            return;
        }
        if(count($retrieve) >1){
            $j=0;
            foreach($retrieve as $r){
                echo $row[$j];
                if($j<count($retrieve)-1){
                    //echo ",";
                }
                $j++;                            
            }
            echo "\n";
        }
        else{
            echo $row[$retrieve[0]];
            //echo "\n";
        }
        $k++;
    }
    
}

?>
    