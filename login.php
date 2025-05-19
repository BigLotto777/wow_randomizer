<?php
require_once __DIR__ . '/includes/auth.php';
requerLogout(); // Redireciona se já estiver logado

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
    $senha = $_POST['senha'];
    
    if (fazerLogin($email, $senha)) {
        $url = $_SESSION['url_redirect'] ?? 'index.php';
        unset($_SESSION['url_redirect']);
        header("Location: $url");
        exit;
    } else {
        definirMensagem('Email ou senha incorretos', 'erro');
    }
}
?>