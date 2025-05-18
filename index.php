<?php
define('BASE_DIR', __DIR__);

// Verificação de segurança para includes
$headerPath = BASE_DIR . '/includes/header.php';
if (!file_exists($headerPath)) die("Erro: Arquivo header.php não encontrado");
require_once $headerPath;
?>

<style>
    .hero-section {
        background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), 
                    url('assets/img/wow-landscape.jpg') no-repeat center center;
        background-size: cover;
        color: white;
        padding: 8rem 0;
        margin-bottom: 3rem;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
    }
    
    .feature-icon {
        font-size: 2.5rem;
        margin-bottom: 1rem;
    }
</style>

<div class="hero-section">
    <div class="container text-center">
        <h1 class="display-3 fw-bold mb-4">Randomizador de Personagens WoW</h1>
        <p class="lead fs-3 mb-5">Gere combinações aleatórias para sua próxima aventura em Azeroth!</p>
        
        <div class="d-flex justify-content-center gap-3">
            <a href="randomizer.php" class="btn btn-primary btn-lg px-4 py-3">
                <i class="fas fa-random me-2"></i> Gerar Personagem
            </a>
            <a href="login.php" class="btn btn-outline-light btn-lg px-4 py-3">
                <i class="fas fa-user me-2"></i> Área do Jogador
            </a>
        </div>
    </div>
</div>

<div class="container">
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body text-center p-4">
                    <div class="feature-icon text-primary">
                        <i class="fas fa-flag"></i>
                    </div>
                    <h3>Horda ou Aliança</h3>
                    <p class="text-muted">Escolha sua facção ou surpreenda-se com um personagem aleatório</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body text-center p-4">
                    <div class="feature-icon text-danger">
                        <i class="fas fa-helmet-battle"></i>
                    </div>
                    <h3>12 Classes</h3>
                    <p class="text-muted">Desde guerreiros até cavaleiros da morte e caçadores de demônios</p>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card h-100 border-0 shadow-sm">
                <div class="card-body text-center p-4">
                    <div class="feature-icon text-success">
                        <i class="fas fa-book-spells"></i>
                    </div>
                    <h3>36 Especializações</h3>
                    <p class="text-muted">Tank, Healer ou DPS - encontre seu estilo de jogo ideal</p>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
$footerPath = BASE_DIR . '/includes/footer.php';
if (!file_exists($footerPath)) die("Erro: Arquivo footer.php não encontrado");
require_once $footerPath;
?>