<?php
session_start();
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WoW Randomizer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-wow">

<!-- ✅ Header -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-warning shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="index.php">
            <img src="assets/img/wow-logo.png" alt="WoW" width="35">
            WoW Randomizer
        </a>
        <div class="d-flex">
            <a href="randomizer.php" class="btn btn-outline-light btn-sm me-2">Gerar Personagem</a>
            <?php if (isset($_SESSION['usuario_id'])): ?>
                <a href="dashboard.php" class="btn btn-outline-info btn-sm me-2">Dashboard</a>
                <a href="logout.php" class="btn btn-danger btn-sm">Logout</a>
            <?php else: ?>
                <a href="login.php" class="btn btn-outline-light btn-sm me-2">Login</a>
                <a href="register.php" class="btn btn-warning btn-sm">Registrar</a>
            <?php endif; ?>
        </div>
    </div>
</nav>

<!-- ✅ Conteúdo principal -->
<div class="container main-content">
    <div class="bg-blur-box mb-4">
        <h1 class="wow-title mb-4">
            <img src="assets/img/wow-logo.png" class="wow-icon">
            WoW Randomizer
        </h1>
        <p class="lead mb-4">Bem-vindo ao Randomizador de Personagens de World of Warcraft.</p>
        <a href="randomizer.php" class="btn btn-primary btn-lg">🎲 Gerar Personagem Aleatório</a>
    </div>

    <!-- ✅ Seção de informações -->
    <div class="row justify-content-center">
        <!-- Fações -->
        <div class="col-md-3 info-box">
            <h4>Escolha sua Facção!</h4>
            <img src="assets/img/icons/faccao_h.png" alt="Horda">
            <img src="assets/img/icons/faccao_a.png" alt="Aliança">
            <p>Horda ou Aliança? Escolha seu lado!</p>
        </div>

        <!-- Raças -->
        <div class="col-md-3 info-box">
            <h4>12 Raças!</h4>
            <?php
            $racas = ['Humano', 'Anao', 'Elfo Noturno', 'Gnomo', 'Draenei', 'Worgen', 'Orc', 'Tauren', 'Troll', 'Elfo Sangrento', 'Goblin', 'Renegado'];
            foreach ($racas as $raca) {
                $icone = strtolower(str_replace(' ', '_', $raca));
                echo "<img src='assets/img/racas/{$icone}_m.png' alt='{$raca}' title='{$raca}'>";
            }
            ?>
            <p>Escolha entre 12 raças lendárias!</p>
        </div>

        <!-- Classes -->
        <div class="col-md-3 info-box">
            <h4>12 Classes!</h4>
            <?php
            $classes = ['Guerreiro', 'Caçador', 'Mago', 'Ladino', 'Sacerdote', 'Bruxo', 'Paladino', 'Druida', 'Xamã', 'Monge', 'Caçador de Demônios', 'Cavaleiro da Morte'];
            foreach ($classes as $classe) {
                $icone = strtolower(str_replace([' ', 'ç', 'ã', 'ô'], ['','c','a','o'], $classe));
                echo "<img src='assets/img/icons/{$icone}.png' alt='{$classe}' title='{$classe}'>";
            }
            ?>
            <p>Aventure-se com 12 classes do WoW!</p>
        </div>
    </div>
</div>

<!-- ✅ Footer -->
<footer class="text-center text-light p-3">
    <small>&copy; <?= date('Y') ?> WoW Randomizer. Por Vitor Beloto.</small>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
