<?php
session_start();
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/conexao.php';

$erro = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome_usuario = $_POST['usuario'] ?? '';
    $senha = $_POST['senha'] ?? '';

    $stmt = $conn->prepare("SELECT id, senha_hash FROM usuarios WHERE nome_usuario = ?");
    $stmt->bind_param("s", $nome_usuario);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows === 1) {
        $stmt->bind_result($id, $senha_hash);
        $stmt->fetch();

        if (password_verify($senha, $senha_hash)) {
            $_SESSION['usuario_id'] = $id;
            $_SESSION['nome_usuario'] = $nome_usuario;

            header('Location: dashboard.php');
            exit;
        } else {
            $erro = 'Senha incorreta.';
        }
    } else {
        $erro = 'Usuário não encontrado.';
    }
    $stmt->close();
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Login | WoW Randomizer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body style="background-color: #111;">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-warning shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="index.php">
            <img src="assets/img/wow-logo.png" alt="WoW" width="35"> WoW Randomizer
        </a>
        <div>
            <a href="randomizer.php" class="btn btn-outline-light btn-sm me-2">Gerar Personagem</a>
            <a href="login.php" class="btn btn-outline-light btn-sm me-2">Login</a>
            <a href="register.php" class="btn btn-warning btn-sm">Registrar</a>
        </div>
    </div>
</nav>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <div class="card p-4 wow-card fade-in" style="max-width: 450px;">
        <h2 class="wow-title text-center mb-3">
            <img src="assets/img/wow-logo.png" class="wow-icon"> Login
        </h2>

        <?php if ($erro): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($erro) ?></div>
        <?php endif; ?>

        <form method="post">
            <div class="mb-3">
                <label class="form-label">Nome de usuário</label>
                <input type="text" name="usuario" class="form-control" placeholder="Digite seu nome de usuário" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Senha</label>
                <input type="password" name="senha" class="form-control" placeholder="Digite sua senha" required>
            </div>
            <div class="d-grid">
                <button class="btn btn-primary" type="submit">Entrar</button>
            </div>
            <div class="text-center mt-2">
                <a href="register.php">Criar uma conta</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
