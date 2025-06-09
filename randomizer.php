<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/conexao.php';
require_once __DIR__ . '/includes/config.php';

function sanitize_icon_name($string, $is_race = false)
{
    $string = strtolower($string);
    $string = str_replace(
        ['ã', 'á', 'â', 'à', 'é', 'ê', 'í', 'ó', 'ô', 'õ', 'ú', 'ç'],
        ['a', 'a', 'a', 'a', 'e', 'e', 'i', 'o', 'o', 'o', 'u', 'c'],
        $string
    );
    if ($is_race) {
        $string = str_replace(' ', '_', $string);
    } else {
        $string = str_replace(' ', '', $string);
    }
    return $string;
}

$personagem = null;
$erro = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario_id = $_SESSION['usuario_id'] ?? null;
    $faccao = $_POST['faccao'] ?: null;
    $funcao = $_POST['funcao'] ?: null;
    $tipo_combate = $_POST['tipo_combate'] ?: null;

    try {
        $stmt = $conn->prepare("CALL sp_gerar_personagem(?, ?, ?, ?)");
        $stmt->bind_param("isss", $usuario_id, $faccao, $funcao, $tipo_combate);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $classe = strtolower($row['classe']);
                $raca = strtolower($row['raca']);

                if ($classe === 'caçador de demônios') {
                    if (!in_array($raca, ['elfo noturno', 'elfa noturna', 'elfo sangrento', 'elfa sangrenta'])) {
                        continue;
                    }
                }

                $personagem = $row;
                break;
            }
        }

        while ($conn->more_results() && $conn->next_result()) {
            $conn->use_result();
        }
    } catch (mysqli_sql_exception $e) {
        $erro = "Erro ao gerar personagem: " . $e->getMessage();
    }
}
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Randomizador | WoW</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>

<body style="background-color: #111;">

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-warning shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.php">
                <img src="assets/img/wow-logo.png" alt="WoW" width="35" class="d-inline-block align-text-top">
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

    <div class="container mt-5">
        <h2 class="text-center mb-4">Gerar Novo Aventureiro!</h2>

        <form method="post" class="mb-4">
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Facção:</label>
                    <select name="faccao" class="form-select">
                        <option value="">Qualquer</option>
                        <option value="H">Horda</option>
                        <option value="A">Aliança</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Função:</label>
                    <select name="funcao" class="form-select">
                        <option value="">Qualquer</option>
                        <option value="DPS">DPS</option>
                        <option value="Tank">Tank</option>
                        <option value="Healer">Healer</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Tipo de Combate:</label>
                    <select name="tipo_combate" class="form-select">
                        <option value="">Qualquer</option>
                        <option value="Melee">Melee</option>
                        <option value="Ranged">Ranged</option>
                        <option value="Híbrido">Híbrido</option>
                    </select>
                </div>
                <div class="col-12 d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-random me-2"></i>Gerar
                    </button>
                </div>
            </div>
        </form>

        <?php if ($erro): ?>
            <div class="alert alert-danger"><?= htmlspecialchars($erro) ?></div>
        <?php elseif ($personagem): ?>
            <div class="card wow-card fade-in mb-4">
                <div class="card-body">
                    <h3 class="wow-title">
                        <img class="wow-icon" src="assets/img/wow-logo.png" alt="World of Warcraft">
                        Seu personagem foi gerado!
                    </h3>

                    <!-- Facção -->
                    <p>
                        <span class="wow-label">🏳️ Facção:</span>
                        <?php
                        $facCode = strtolower($personagem['faccao']) === 'h' ? 'h' : 'a';
                        echo "<img class='wow-icon' src='assets/img/icons/faccao_{$facCode}.png' alt='Facção'> ";
                        echo "<span class='wow-info-text'>" . htmlspecialchars($personagem['faccao']) . "</span>";
                        ?>
                    </p>

                    <!-- Raça -->
                    <p>
                        <span class="wow-label">🧬 Raça:</span>
                        <?php
                        $racaOriginal = $personagem['raca'];
                        $genero = rand(0, 1) === 0 ? '_m' : '_f';
                        $racaSan = sanitize_icon_name($racaOriginal, true);
                        $racaKey = "{$racaSan}{$genero}";
                        $iconeRaca = "assets/img/racas/{$racaKey}.png";

                        $mapaGenero = [
                            'anao_f' => 'Ana',
                            'orc_f' => 'Orquisa',
                            'tauren_f' => 'Taurena',
                            'troll_f' => 'Trollesa',
                            'elfo_noturno_f' => 'Elfa Noturna',
                            'elfo_sangrento_f' => 'Elfa Sangrenta',
                            'draenei_f' => 'Draenei Fêmea',
                            'goblin_f' => 'Goblin Fêmea',
                            'worgen_f' => 'Worgen Fêmea',
                            'gnomo_f' => 'Gnoma',
                            'renegado_f' => 'Renegada',
                            'renegado_m' => 'Renegado'
                        ];

                        $label = $mapaGenero[$racaKey] ?? $racaOriginal;

                        echo "<img class='wow-icon' src='{$iconeRaca}' alt='{$label}'> ";
                        echo "<span class='wow-info-text'>" . htmlspecialchars($label) . "</span>";
                        ?>
                    </p>

                    <!-- Classe -->
                    <p>
                        <span class="wow-label">⚔️ Classe:</span>
                        <?php
                        $classeSan = sanitize_icon_name($personagem['classe']);
                        $classeIcon = "assets/img/icons/{$classeSan}.png";
                        $corClasse = $personagem['cor_hex'] ?? '#FFD700';

                        echo "<img class='wow-icon' src='{$classeIcon}' alt='Classe'> ";
                        echo "<span class='wow-badge' style='background-color: {$corClasse}'>" . htmlspecialchars($personagem['classe']) . "</span>";
                        echo " <span class='wow-info-text'>(" . htmlspecialchars($personagem['tipo_combate']) . ")</span>";
                        ?>
                    </p>

                    <!-- Especialização -->
                    <p>
                        <span class="wow-label">🌟 Especialização:</span>
                        <span class="wow-special">
                            <?= htmlspecialchars($personagem['especializacao']) ?>
                            (<?= htmlspecialchars($personagem['funcao']) ?>)
                        </span>
                    </p>

                    <?php if (!empty($personagem['descricao'])): ?>
                        <div class="descricao-especializacao">
                            <h5>Sobre a Especialização</h5>
                            <p><?= htmlspecialchars($personagem['descricao']) ?></p>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        <?php endif; ?>
    </div>

    <footer class="text-center text-light mt-4 p-3" style="background-color: #222;">
        <small>&copy; <?= date('Y') ?> WoW Randomizer. Por Vitor Beloto.</small>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
