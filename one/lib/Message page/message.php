<?php
// Account details
$apiKey = urlencode('NTgzMjMwNGM0YTMzNTg1OTQ0NjQ2ZTRiMzM3YTQ2NmU=');
// Message details
$numbers = array($_POST['number']); 
$sender = urlencode('KENNED');
$message = rawurlencode($_POST['message']);

$numbers = implode(',', $numbers);
 
// Prepare data for POST request
$data = array('apikey' => $apiKey, 'numbers' => $numbers, "sender" => $sender, "message" => $message, "unicode" => true);
// Send the POST request with cURL
$ch = curl_init('https://api.textlocal.in/send/');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
curl_close($ch);
// Process your response here
echo $response;
?>