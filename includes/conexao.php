<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "wow_randomizer";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Falha na conexão: " . $conn->connect_error);
}

// Definir charset para utf8
$conn->set_charset("utf8mb4");
?>