<?php
	// Account details
	$apiKey = urlencode('NTgzMjMwNGM0YTMzNTg1OTQ0NjQ2ZTRiMzM3YTQ2NmU=');
 
	// Prepare data for POST request
	$data = 'apikey=' . $apiKey;
 
	// Send the GET request with cURL
	$ch = curl_init('https://api.textlocal.in/balance/?' . $data);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	$response = curl_exec($ch);
	curl_close($ch);
	
	// Process your response here
	echo $response;
?>