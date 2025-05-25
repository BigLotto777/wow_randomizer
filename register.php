<?php
session_start();
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/conexao.php';

$erro = '';
$sucesso = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome_usuario = $_POST['usuario'] ?? '';
    $email = $_POST['email'] ?? '';
    $senha = $_POST['senha'] ?? '';
    $senha2 = $_POST['senha2'] ?? '';

    if ($senha !== $senha2) {
        $erro = 'As senhas não coincidem.';
    } else {
        $stmt = $conn->prepare("SELECT id FROM usuarios WHERE nome_usuario = ? OR email = ?");
        $stmt->bind_param("ss", $nome_usuario, $email);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            $erro = 'Usuário ou E-mail já cadastrado.';
        } else {
            $senha_hash = password_hash($senha, PASSWORD_DEFAULT);
            $stmt = $conn->prepare("INSERT INTO usuarios (nome_usuario, email, senha_hash, data_cadastro, ativo) VALUES (?, ?, ?, NOW(), 1)");
            $stmt->bind_param("sss", $nome_usuario, $email, $senha_hash);

            if ($stmt->execute()) {
                $sucesso = 'Cadastro realizado com sucesso! Você pode fazer login.';
            } else {
                $erro = 'Erro ao cadastrar usuário.';
            }
        }
        $stmt->close();
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro | WoW Randomizer</title>
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
            <img src="assets/img/wow-logo.png" class="wow-icon"> Cadastro
        </h2>

        <?php if ($erro): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($erro) ?></div>
        <?php elseif ($sucesso): ?>
            <div class="alert alert-success"><?= htmlspecialchars($sucesso) ?></div>
        <?php endif; ?>

        <form method="post">
            <div class="mb-3">
                <label class="form-label">Nome de usuário</label>
                <input type="text" name="usuario" class="form-control" placeholder="Nome de usuário" required>
            </div>
            <div class="mb-3">
                <label class="form-label">E-mail</label>
                <input type="email" name="email" class="form-control" placeholder="E-mail" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Senha</label>
                <input type="password" name="senha" class="form-control" placeholder="Senha" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Confirmar Senha</label>
                <input type="password" name="senha2" class="form-control" placeholder="Confirmar Senha" required>
            </div>
            <div class="d-grid">
                <button class="btn btn-success" type="submit">Cadastrar</button>
            </div>
            <div class="text-center mt-2">
                <a href="login.php">Já possui uma conta? Login</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
