<?php
session_start();
if (!isset($_SESSION['usuario_id'])) {
    header('Location: index.php');
    exit;
}
require_once 'config/conexao.php';

$stmt = $pdo->query("SELECT * FROM produto ORDER BY id DESC");
$produtos = $stmt->fetchall(PDO::FETCH_ASSOC);

require 'includes/header_app.php';
?>

<div class="topo-pagina">
    <div>
        <h1>Produtos</h1>
        <p class="subtitulo-pagina"><?php echo count($produtos); ?> produtos cadastrados</p>
    </div>
</div>

<table class="tabela-produtos">
    <thead>
        <tr>
            <th>PRODUTO</th>
            <th>CATEGORIA</th>
            <th>CUSTO</th>
            <th>VENDA</th>
            <th>ESTOQUE</th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($produtos as $produto): ?>
        <tr>
            <td>
                <strong><?php echo htmlspecialchars($produto['nome']); ?></strong>
                <br>
                <span class="texto-secundario"><?php echo htmlspecialchars($produto['descricao']); ?></span>
            </td>
            <td><?php echo htmlspecialchars($produto['categoria']); ?></td>
            <td>R$ <?php echo number_format($produto['valor_custo'], 2, ',', '.'); ?></td>
            <td><strong>R$ <?php echo number_format($produto['valor_venda'], 2, ',', '.'); ?></strong></td>
            <td><?php echo $produto['estoque']; ?></td>
            <td></td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>


<?php require 'includes/footer_app.php'; ?>