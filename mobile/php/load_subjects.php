<?php 

if (!isset($_POST)) {
    $response = array('status'=>'failed', 'data'=>null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$sqlloadsubject = "SELECT * FROM tbl_subjects";
$result = $conn->query($sqlloadsubject);
if($result->num_rows > 0){
    $subjects["subjects"] = array();
    while ($row = $result->fetch_assoc())
    {
        $subjectslist = array();
        $subjectslist['subject_id'] = $row['subject_id'];
        $subjectslist['subject_name'] = $row['subject_name'];
        $subjectslist['subject_description'] = $row['subject_description'];
        $subjectslist['subject_price'] = $row['subject_price'];
        $subjectslist['tutor_id'] = $row['tutor_id'];
        $subjectslist['subject_sessions'] = $row['subject_sessions'];
        $subjectslist['subject_rating'] = $row['subject_rating'];
        array_push($subjects['subjects'], $subjectslist);
    }
    $response = array('status'=>'success', 'data'=>$subjects);
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