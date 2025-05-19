<?php
/**
 * Sistema de Autenticação para WoW Randomizer
 * Funções:
 * - Inicia sessões seguras
 * - Verifica login
 * - Protege páginas restritas
 * - Gerencia redirecionamentos
 */

// Configurações de segurança
session_start([
    'cookie_lifetime' => 86400, // 24 horas
    'cookie_secure'   => false, // true em produção com HTTPS
    'cookie_httponly' => true,
    'use_strict_mode' => true
]);

// Conexão com banco de dados
require_once __DIR__ . '/conexao.php';

/**
 * Verifica se usuário está logado
 * Redireciona para login se não estiver
 */
function requerLogin() {
    if (!isset($_SESSION['usuario_id'])) {
        $_SESSION['url_redirect'] = $_SERVER['REQUEST_URI'];
        header('Location: login.php');
        exit();
    }
}

/**
 * Verifica se usuário NÃO está logado
 * Redireciona para página inicial se estiver logado
 */
function requerLogout() {
    if (isset($_SESSION['usuario_id'])) {
        header('Location: index.php');
        exit();
    }
}

/**
 * Realiza login do usuário
 * @param string $email
 * @param string $senha
 * @return bool True se login for bem-sucedido
 */
function fazerLogin($email, $senha) {
    global $conn;
    
    $stmt = $conn->prepare("SELECT id, nome_usuario, senha_hash FROM usuarios WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows === 1) {
        $usuario = $result->fetch_assoc();
        if (password_verify($senha, $usuario['senha_hash'])) {
            // Login bem-sucedido
            $_SESSION['usuario_id'] = $usuario['id'];
            $_SESSION['nome_usuario'] = $usuario['nome_usuario'];
            return true;
        }
    }
    
    return false;
}

/**
 * Realiza logout do usuário
 */
function fazerLogout() {
    $_SESSION = array();
    
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
    }
    
    session_destroy();
}

/**
 * Retorna informações do usuário logado
 * @return array|null Dados do usuário ou null se não logado
 */
function usuarioAtual() {
    if (isset($_SESSION['usuario_id'])) {
        return [
            'id' => $_SESSION['usuario_id'],
            'nome' => $_SESSION['nome_usuario']
        ];
    }
    return null;
}

/**
 * Verifica se há mensagem flash armazenada
 */
function temMensagem() {
    return isset($_SESSION['mensagem_flash']);
}

/**
 * Obtém e remove mensagem flash
 */
function obterMensagem() {
    if (temMensagem()) {
        $mensagem = $_SESSION['mensagem_flash'];
        unset($_SESSION['mensagem_flash']);
        return $mensagem;
    }
    return null;
}

/**
 * Armazena mensagem flash
 */
function definirMensagem($mensagem, $tipo = 'sucesso') {
    $_SESSION['mensagem_flash'] = [
        'texto' => $mensagem,
        'tipo' => $tipo
    ];
}