<?php 
$host = 'localhost';
$port = '3307';
$dbname = 'ravia_db';
$usuario = 'root';
$senha = '';


try {
    $pdo = new PDO("mysql:host=$host;
                    port=$port;
                    dbname=$dbname;
                    charset=utf8mb4", 
                    $usuario, $senha);
                    
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erro na conexão: " . $e->getMessage());
}

?>