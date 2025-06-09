<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/conexao.php';
require_once __DIR__ . '/includes/config.php';

$usuario_id = $_SESSION['usuario_id'];
$mensagem = '';
$erro = '';

// Obter dados atuais do usuário
$stmt = $conn->prepare("SELECT nome_usuario, email FROM usuarios WHERE id = ?");
$stmt->bind_param("i", $usuario_id);
$stmt->execute();
$stmt->bind_result($nome_atual, $email_atual);
$stmt->fetch();
$stmt->close();

// Atualização de dados
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $novo_nome = trim($_POST['nome_usuario']);
    $novo_email = trim($_POST['email']);
    $nova_senha = $_POST['nova_senha'];
    $confirmar_senha = $_POST['confirmar_senha'];

    if (empty($novo_nome) || empty($novo_email)) {
        $erro = "Nome e e-mail são obrigatórios.";
    } elseif (!filter_var($novo_email, FILTER_VALIDATE_EMAIL)) {
        $erro = "E-mail inválido.";
    } elseif (!empty($nova_senha) && $nova_senha !== $confirmar_senha) {
        $erro = "As senhas não coincidem.";
    } else {
        // Atualiza nome e e-mail
        $stmt = $conn->prepare("UPDATE usuarios SET nome_usuario = ?, email = ? WHERE id = ?");
        $stmt->bind_param("ssi", $novo_nome, $novo_email, $usuario_id);
        $stmt->execute();
        $stmt->close();

        // Atualiza senha, se informada
        if (!empty($nova_senha)) {
            $hash = password_hash($nova_senha, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("UPDATE usuarios SET senha_hash = ? WHERE id = ?");
            $stmt->bind_param("si", $hash, $usuario_id);
            $stmt->execute();
            $stmt->close();
        }

        $_SESSION['nome_usuario'] = $novo_nome;
        $mensagem = "Dados atualizados com sucesso!";
        $nome_atual = $novo_nome;
        $email_atual = $novo_email;
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Configurações | WoW Randomizer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-dark text-white">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-warning shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.php">
                <img src="assets/img/wow-logo.png" alt="WoW" width="35" class="d-inline-block align-text-top">
                WoW Randomizer
            </a>
            <div class="d-flex">
                <a href="dashboard.php" class="btn btn-outline-warning btn-sm me-2">Dashboard</a>
                <a href="logout.php" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2 class="wow-title text-center mb-4">⚙️ Configurações da Conta</h2>

        <?php if ($mensagem): ?>
            <div class="alert alert-success"><?= $mensagem ?></div>
        <?php elseif ($erro): ?>
            <div class="alert alert-danger"><?= $erro ?></div>
        <?php endif; ?>

        <div class="card wow-card">
            <div class="card-body">
                <form method="post">
                    <div class="mb-3">
                        <label class="form-label">Nome de Usuário</label>
                        <input type="text" name="nome_usuario" class="form-control" value="<?= htmlspecialchars($nome_atual) ?>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">E-mail</label>
                        <input type="email" name="email" class="form-control" value="<?= htmlspecialchars($email_atual) ?>" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nova Senha</label>
                        <input type="password" name="nova_senha" class="form-control" placeholder="Deixe em branco para manter a atual">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Confirmar Nova Senha</label>
                        <input type="password" name="confirmar_senha" class="form-control" placeholder="Repita a nova senha">
                    </div>
                    <button type="submit" class="btn btn-warning fw-bold">Salvar Alterações</button>
                </form>
            </div>
        </div>
    </div>

    <footer class="text-center text-light mt-4 p-3">
        <small>&copy; <?= date('Y') ?> WoW Randomizer. Por Vitor Beloto.</small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
