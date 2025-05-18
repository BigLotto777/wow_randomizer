<?php
include 'includes/conexao.php';
include 'includes/auth.php'; // Para verificar se o usuário está logado
?>

<?php include 'includes/header.php'; ?>

<div class="container mt-5">
    <h2>Gerar Personagem Aleatório</h2>
    
    <form method="post" class="mb-4">
        <div class="row">
            <div class="col-md-4">
                <label>Facção:</label>
                <select name="faccao" class="form-control">
                    <option value="">Qualquer</option>
                    <option value="H">Horda</option>
                    <option value="A">Aliança</option>
                </select>
            </div>
            <div class="col-md-4">
                <label>Função:</label>
                <select name="funcao" class="form-control">
                    <option value="">Qualquer</option>
                    <option value="DPS">DPS</option>
                    <option value="Tank">Tank</option>
                    <option value="Healer">Healer</option>
                </select>
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-primary mt-4">Gerar</button>
            </div>
        </div>
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        $faccao = $_POST['faccao'] ?? null;
        $funcao = $_POST['funcao'] ?? null;
        
        $stmt = $conn->prepare("CALL sp_gerar_personagem(?, ?, ?, NULL)");
        $stmt->bind_param("iss", $_SESSION['user_id'], $faccao, $funcao);
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
    }
    ?>
</div>

<?php include 'includes/footer.php'; ?>