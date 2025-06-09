<?php
session_start();
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/conexao.php';

if (!isset($_SESSION['usuario_id'])) {
    header('Location: login.php');
    exit;
}

$usuario_id = $_SESSION['usuario_id'];
$nome_usuario = $_SESSION['nome_usuario'];

// 🔥 Deletar uma única randomização
if (isset($_GET['delete'])) {
    $delete_id = intval($_GET['delete']);
    $stmt = $conn->prepare("DELETE FROM historico_randomizacoes WHERE id = ? AND usuario_id = ?");
    $stmt->bind_param("ii", $delete_id, $usuario_id);
    $stmt->execute();
    header('Location: historico.php');
    exit;
}

// 🔥 Limpar todo o histórico
if (isset($_GET['clear'])) {
    $stmt = $conn->prepare("DELETE FROM historico_randomizacoes WHERE usuario_id = ?");
    $stmt->bind_param("i", $usuario_id);
    $stmt->execute();
    header('Location: historico.php');
    exit;
}

// 🔍 Buscar histórico do usuário
$query = $conn->prepare("
    SELECT id, faccao, raca, classe, especializacao, funcao, tipo_combate, data_geracao 
    FROM historico_randomizacoes 
    WHERE usuario_id = ? 
    ORDER BY data_geracao DESC
");
$query->bind_param("i", $usuario_id);
$query->execute();
$result = $query->get_result();

function sanitize_icon_name($string, $is_race = false) {
    $string = strtolower($string);
    $string = str_replace(
        ['ã','á','â','à','é','ê','í','ó','ô','õ','ú','ç'],
        ['a','a','a','a','e','e','i','o','o','o','u','c'],
        $string
    );
    $string = trim($string);
    return $is_race ? str_replace(' ', '_', $string) : str_replace(' ', '', $string);
}
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Histórico | WoW Randomizer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body style="background-color: #111;">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-warning shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="index.php">
            <img src="assets/img/wow-logo.png" alt="WoW" width="35">
            WoW Randomizer
        </a>
        <div>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Dashboard</a>
            <a href="randomizer.php" class="btn btn-outline-light btn-sm me-2">Randomizador</a>
            <a href="logout.php" class="btn btn-danger btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="wow-title text-center mb-4">
        <img src="assets/img/wow-logo.png" class="wow-icon">
        Histórico de Personagens de <?= htmlspecialchars($nome_usuario) ?>
    </h2>

    <?php if ($result->num_rows > 0): ?>
        <div class="d-flex justify-content-end mb-2">
            <a href="historico.php?clear=1" class="btn btn-danger btn-sm"
               onclick="return confirm('Tem certeza que deseja limpar todo o histórico?')">
               🗑️ Limpar Histórico
            </a>
        </div>

        <div class="table-responsive">
            <table class="table table-dark table-bordered align-middle text-center">
                <thead class="table-dark text-warning border-bottom border-warning">
                    <tr>
                        <th>Data</th>
                        <th>Facção</th>
                        <th>Raça</th>
                        <th>Classe</th>
                        <th>Especialização</th>
                        <th>Função</th>
                        <th>Tipo</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while ($row = $result->fetch_assoc()):
                        $icone_faccao = 'assets/img/icons/faccao_' . strtolower($row['faccao']) . '.png';
                        $raca_san = sanitize_icon_name($row['raca'], true);
                        $classe_san = sanitize_icon_name($row['classe']);
                        $icone_raca = "assets/img/racas/{$raca_san}_m.png";
                        $icone_classe = "assets/img/icons/{$classe_san}.png";
                    ?>
                        <tr>
                            <td><?= date('d/m/Y H:i', strtotime($row['data_geracao'])) ?></td>
                            <td>
                                <img src="<?= $icone_faccao ?>" width="30" alt="Facção">
                                <br><?= htmlspecialchars($row['faccao']) ?>
                            </td>
                            <td>
                                <img src="<?= $icone_raca ?>" width="30" alt="Raça">
                                <br><?= htmlspecialchars($row['raca']) ?>
                            </td>
                            <td>
                                <img src="<?= $icone_classe ?>" width="30" alt="Classe">
                                <br><?= htmlspecialchars($row['classe']) ?>
                            </td>
                            <td><?= htmlspecialchars($row['especializacao']) ?></td>
                            <td><?= htmlspecialchars($row['funcao']) ?></td>
                            <td><?= htmlspecialchars($row['tipo_combate']) ?></td>
                            <td>
                                <a href="historico.php?delete=<?= $row['id'] ?>" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Deseja excluir este registro?')">
                                   Excluir
                                </a>
                            </td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    <?php else: ?>
        <div class="alert alert-info text-center">
            ⚠️ Você ainda não gerou nenhum personagem.
        </div>
    <?php endif; ?>

    <div class="text-center mt-4">
        <a href="dashboard.php" class="btn btn-secondary me-2">Voltar para Dashboard</a>
        <a href="randomizer.php" class="btn btn-primary">Gerar Novo Personagem</a>
    </div>
</div>

<footer class="text-center text-light mt-4 p-3" style="background-color: #222;">
    <small>&copy; <?= date('Y') ?> WoW Randomizer. Por Vitor Beloto.</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
