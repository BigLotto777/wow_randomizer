<?php
session_start();
require_once __DIR__ . '/includes/config.php';
require_once __DIR__ . '/includes/conexao.php';

// Verificar se está logado
if (!isset($_SESSION['usuario_id'])) {
    header('Location: login.php');
    exit;
}

$nome_usuario = $_SESSION['nome_usuario'] ?? 'Aventureiro';
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | WoW Randomizer</title>
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

<div class="container text-center mt-5">
    <h1 class="wow-title mb-3">
        <img src="assets/img/wow-logo.png" class="wow-icon">
        Bem-vindo, <?= htmlspecialchars($nome_usuario) ?>!
    </h1>
    <p class="text-light mb-5">O que você deseja fazer hoje no mundo de Azeroth?</p>

    <div class="row g-4 justify-content-center">
        <!-- Card 1 -->
        <div class="col-md-5">
            <div class="card wow-card fade-in h-100">
                <div class="card-body">
                    <h4 class="card-title mb-3">🎲 Gerar Personagem</h4>
                    <p class="card-text">Crie um personagem aleatório com raça, classe e especialização seguindo a lore do WoW.</p>
                    <a href="randomizer.php" class="btn btn-primary">Ir para Randomizador</a>
                </div>
            </div>
        </div>
        <!-- Card 2 - Histórico -->
        <div class="col-md-5">
            <div class="card wow-card fade-in h-100">
                <div class="card-body">
                    <h4 class="card-title mb-3">📜 Meu Histórico</h4>
                    <p class="card-text">Veja todos os personagens que você já gerou enquanto explorava Azeroth.</p>
                    <a href="historico.php" class="btn btn-warning">Ver Histórico</a>
                </div>
            </div>
        </div>
        <!-- Card 3 - Configurações -->
        <div class="col-md-5">
            <div class="card wow-card fade-in h-100">
                <div class="card-body">
                    <h4 class="card-title mb-3">⚙️ Configurações</h4>
                    <p class="card-text">Gerencie sua conta, altere sua senha ou atualize seu perfil.</p>
                    <button class="btn btn-secondary" disabled>Em desenvolvimento</button>
                </div>
            </div>
        </div>
        <!-- Card 4 - Logout -->
        <div class="col-md-5">
            <div class="card wow-card fade-in h-100">
                <div class="card-body">
                    <h4 class="card-title mb-3">🚪 Sair</h4>
                    <p class="card-text">Encerrar sua sessão e retornar para o mundo real.</p>
                    <a href="logout.php" class="btn btn-danger">Logout</a>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="text-center text-light mt-5 p-3" style="background-color: #222;">
    <small>&copy; <?= date('Y') ?> WoW Randomizer. Por Vitor Beloto.</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
