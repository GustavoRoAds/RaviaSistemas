<?php
header('Content-Type: application/json; charset=utf-8');

require __DIR__ . '/../config/conexao.php';

$stmt = $pdo->query('SELECT * FROM categoria ORDER BY id');
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));