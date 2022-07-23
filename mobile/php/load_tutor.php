<?php 

if (!isset($_POST)) {
    $response = array('status'=>'failed', 'data'=>null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$sqlloadtutors = "SELECT * FROM tbl_tutors";
$result = $conn->query($sqlloadtutors);
if($result->num_rows > 0){
    $tutors["tutors"] = array();
    while ($row = $result->fetch_assoc())
    {
        $tutorslist = array();
        $tutorslist['tutor_id'] = $row['tutor_id'];
        $tutorslist['tutor_email'] = $row['tutor_email'];
        $tutorslist['tutor_phone'] = $row['tutor_phone'];
        $tutorslist['tutor_name'] = $row['tutor_name'];
        $tutorslist['tutor_password'] = $row['tutor_password'];
        $tutorslist['tutor_description'] = $row['tutor_description'];
        $tutorslist['tutor_datereg'] = $row['tutor_datereg'];
        array_push($tutors['tutors'], $tutorslist);
    }
    $response = array('status'=>'success', 'data'=>$tutors);
    sendjsonResponse($response);
}else{
    $response = array('status'=>'failed', 'data'=>null);
    sendjsonResponse($response);
}

function sendjsonResponse($sendArray) 
{
    header('Content-Type: application/json');
    echo json_encode($sendArray);    
}

?>