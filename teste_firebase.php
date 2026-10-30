<?php

$caminho = getenv('FIREBASE_CREDENTIALS_PATH');

echo 'Caminho: ' . htmlspecialchars($caminho ?: 'Não configurado');

echo '<br>';

if ($caminho && is_file($caminho)) {
    echo 'Arquivo JSON encontrado!';
} else {
    echo 'Arquivo JSON não encontrado!';
}
