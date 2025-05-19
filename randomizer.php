<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/conexao.php';

// Verifica se o usuário está logado
if (!isset($_SESSION['usuario_id'])) {
    // Se não estiver logado, usa um valor padrão (0 ou NULL, conforme sua tabela permitir)
    $usuario_id = 0; // Ou NULL se a coluna permitir
    // Alternativamente, redirecione para login:
    // header('Location: login.php?redirect='.urlencode($_SERVER['REQUEST_URI']));
    // exit();
} else {
    $usuario_id = $_SESSION['usuario_id'];
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $faccao = $_POST['faccao'] ?? null;
    $funcao = $_POST['funcao'] ?? null;
    
    try {
        $stmt = $conn->prepare("CALL sp_gerar_personagem(?, ?, ?, NULL)");
        $stmt->bind_param("iss", $usuario_id, $faccao, $funcao);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows > 0) {
            $personagem = $result->fetch_assoc();
            echo '<div class="alert alert-success">';
            echo "<h4>Seu personagem:</h4>";
            echo "<p><strong>Raça:</strong> {$personagem['raca']} ({$personagem['faccao']})</p>";
            echo "<p><strong>Classe:</strong> {$personagem['classe']} ({$personagem['tipo_combate']})</p>";
            echo "<p><strong>Especialização:</strong> {$personagem['especializacao']} ({$personagem['funcao']})</p>";
            echo '</div>';
        }
    } catch (mysqli_sql_exception $e) {
        echo '<div class="alert alert-danger">';
        echo "Erro ao gerar personagem: " . $e->getMessage();
        echo '</div>';
    }
}
?>

<?php include __DIR__ . '/includes/header.php'; ?>

<div class="container mt-5">
    <h2>Gerar Personagem Aleatório</h2>
    
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
            <div class="col-md-4 d-flex align-items-end">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-random me-2"></i>Gerar
                </button>
            </div>
        </div>
    </form>
</div>

<?php include __DIR__ . '/includes/footer.php'; ?>