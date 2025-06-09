<?php
require_once __DIR__ . '/includes/auth.php';
require_once __DIR__ . '/includes/conexao.php';
require_once __DIR__ . '/vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

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

function imageToBase64($path) {
    if (!file_exists($path)) return '';
    $type = pathinfo($path, PATHINFO_EXTENSION);
    $data = file_get_contents($path);
    $base64 = 'data:image/' . $type . ';base64,' . base64_encode($data);
    return $base64;
}

$usuario_id = $_SESSION['usuario_id'];
$nome_usuario = $_SESSION['nome_usuario'] ?? 'Aventureiro';

$stmt = $conn->prepare("
    SELECT faccao, raca, classe, especializacao, funcao, tipo_combate, data_geracao
    FROM historico_randomizacoes
    WHERE usuario_id = ?
    ORDER BY data_geracao DESC
");
$stmt->bind_param("i", $usuario_id);
$stmt->execute();
$result = $stmt->get_result();

$html = '
<h2 style="color:rgb(5, 5, 5); font-family: Arial, sans-serif; text-align:center;">
    Histórico de Personagens - ' . htmlspecialchars($nome_usuario) . '
</h2>
<table width="100%" border="1" cellspacing="0" cellpadding="6" style="border-collapse: collapse; font-family: Arial; font-size: 12px;">
<thead style="background-color: #333; color: #FFD700;">
<tr>
    <th>Data</th>
    <th>Facção</th>
    <th>Raça</th>
    <th>Classe</th>
    <th>Especialização</th>
    <th>Função</th>
    <th>Tipo</th>
</tr>
</thead>
<tbody>';

while ($row = $result->fetch_assoc()) {
    $faccao_icon_path = __DIR__ . '/assets/img/icons/faccao_' . strtolower($row['faccao']) . '.png';
    $raca_icon_path = __DIR__ . '/assets/img/racas/' . sanitize_icon_name($row['raca'], true) . '_m.png';
    $classe_icon_path = __DIR__ . '/assets/img/icons/' . sanitize_icon_name($row['classe']) . '.png';

    $faccao_icon = imageToBase64($faccao_icon_path);
    $raca_icon = imageToBase64($raca_icon_path);
    $classe_icon = imageToBase64($classe_icon_path);

    $html .= '<tr>
        <td>' . date('d/m/Y H:i', strtotime($row['data_geracao'])) . '</td>
        <td><img src="' . $faccao_icon . '" width="24"><br>' . htmlspecialchars($row['faccao']) . '</td>
        <td><img src="' . $raca_icon . '" width="24"><br>' . htmlspecialchars($row['raca']) . '</td>
        <td><img src="' . $classe_icon . '" width="24"><br>' . htmlspecialchars($row['classe']) . '</td>
        <td>' . htmlspecialchars($row['especializacao']) . '</td>
        <td>' . htmlspecialchars($row['funcao']) . '</td>
        <td>' . htmlspecialchars($row['tipo_combate']) . '</td>
    </tr>';
}

$html .= '</tbody></table>';

$options = new Options();
$options->set('isRemoteEnabled', true);
$options->set('defaultFont', 'Arial');

$dompdf = new Dompdf($options);
$dompdf->loadHtml($html);
$dompdf->setPaper('A4', 'portrait');
$dompdf->render();
$dompdf->stream('historico_wow_randomizer.pdf', ['Attachment' => false]);
exit;
