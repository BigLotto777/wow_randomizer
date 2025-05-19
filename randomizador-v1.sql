CREATE DATABASE wow_randomizer CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wow_randomizer;

-- Tabela de usuários (autenticação)
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_usuario VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ultimo_login DATETIME NULL,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Tabela de facções
CREATE TABLE faccoes (
    id CHAR(1) PRIMARY KEY,
    nome VARCHAR(20) NOT NULL,
    descricao TEXT
) ENGINE=InnoDB;

-- Inserção das facções básicas
INSERT INTO faccoes (id, nome, descricao) VALUES 
('H', 'Horda', 'Facção composta por orcs, trolls, taurens, mortos-vivos, elfos sangrentos e goblins'),
('A', 'Aliança', 'Facção composta por humanos, anões, elfos noturnos, gnomes, draeneis e worgens');

-- Tabela de raças
CREATE TABLE racas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    faccao_id CHAR(1) NOT NULL,
    descricao TEXT,
    ativa BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (faccao_id) REFERENCES faccoes(id)
) ENGINE=InnoDB;

-- Inserção de raças da Horda
INSERT INTO racas (nome, faccao_id, descricao) VALUES
('Orc', 'H', 'Guerreiros brutais com sede de batalha'),
('Tauren', 'H', 'Poderosos seres bovinos de grande força física'),
('Troll', 'H', 'Povo espiritual com grande agilidade'),
('Morto-Vivo', 'H', 'Rejeitados que escaparam do controle do Lich Rei'),
('Elfo Sangrento', 'H', 'Ex-elfos nobres corrompidos por magia arcana'),
('Goblin', 'H', 'Engenheiros mercenários ágeis e astutos');

-- Inserção de raças da Aliança
INSERT INTO racas (nome, faccao_id, descricao) VALUES
('Humano', 'A', 'Versáteis e adaptáveis, com espírito resiliente'),
('Anão', 'A', 'Robustos e resistentes, mestres em combate corpo a corpo'),
('Elfo Noturno', 'A', 'Seres místicos conectados à natureza'),
('Gnomo', 'A', 'Pequenos e inteligentes, especialistas em tecnologia'),
('Draenei', 'A', 'Nobres exilados com conexão divina'),
('Worgen', 'A', 'Humanos amaldiçoados com forma lupina');

-- Tabela de classes
CREATE TABLE classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    tipo_combate ENUM('Melee', 'Ranged', 'Híbrido') NOT NULL,
    cor_hex VARCHAR(7) DEFAULT '#FFFFFF',
    icone VARCHAR(50)
) ENGINE=InnoDB;

-- Inserção das classes básicas
INSERT INTO classes (nome, descricao, tipo_combate, cor_hex, icone) VALUES
('Guerreiro', 'Mestres do combate com armas', 'Melee', '#C79C6E', 'class_warrior'),
('Paladino', 'Cavaleiros sagrados da luz', 'Híbrido', '#F58CBA', 'class_paladin'),
('Caçador', 'Especialistas em armas à distância', 'Ranged', '#ABD473', 'class_hunter'),
('Ladino', 'Mestres do combate furtivo', 'Melee', '#FFF569', 'class_rogue'),
('Sacerdote', 'Servos das forças divinas e sombrias', 'Ranged', '#FFFFFF', 'class_priest'),
('Xamã', 'Invocadores dos elementos', 'Híbrido', '#0070DE', 'class_shaman'),
('Mago', 'Mestres das artes arcanas', 'Ranged', '#69CCF0', 'class_mage'),
('Bruxo', 'Conjuradores de magias sombrias', 'Ranged', '#9482C9', 'class_warlock'),
('Monge', 'Mestres das artes marciais', 'Híbrido', '#00FF96', 'class_monk'),
('Druida', 'Guardiões da natureza versáteis', 'Híbrido', '#FF7D0A', 'class_druid'),
('Cavaleiro da Morte', 'Guerreiros runicos amaldiçoados', 'Melee', '#C41F3B', 'class_deathknight'),
('Caçador de Demônios', 'Elfos transformados por magia vil', 'Melee', '#A330C9', 'class_demonhunter');

-- Tabela de especializações
CREATE TABLE especializacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    classe_id INT NOT NULL,
    nome VARCHAR(50) NOT NULL,
    funcao ENUM('DPS', 'Tank', 'Healer') NOT NULL,
    descricao TEXT,
    FOREIGN KEY (classe_id) REFERENCES classes(id)
) ENGINE=InnoDB;

-- Inserção das especializações
INSERT INTO especializacoes (classe_id, nome, funcao, descricao) VALUES
-- Guerreiro
(1, 'Armas', 'DPS', 'Um experiente mestre de armas, que emprega mobilidade e ataques poderosos para destroçar os inimigos.'),
(1, 'Fúria', 'DPS', 'Um berserker furioso empunhando duas armas que desfere uma torrente de ataques para fazer picadinho dos oponentes.'),
(1, 'Proteção', 'Tank', 'Um defensor implacável que usa um escudo para proteger a si mesmo e também os aliados.'),

-- Paladino
(2, 'Sagrado', 'Healer', 'Invoca o poder da Luz para proteger e curar aliados, e derrotar o mal nos cantos mais sombrios do mundo.'),
(2, 'Proteção', 'Tank', 'Utiliza magia Sagrada para se proteger e defender os aliados.'),
(2, 'Retribuição', 'DPS', 'Um cruzado íntegro e justo, que julga e pune os oponentes com armas e magia Sagrada.'),

-- Caçador
(3, 'Domínio das Feras', 'DPS', 'Um mestre da vida selvagem, capaz de domar uma enorme variedade de feras para ajudá-lo em combate.'),
(3, 'Precisão', 'DPS', 'Um exímio atirador, mestre em abater os inimigos à distância.'),
(3, 'Sobrevivência', 'DPS', 'Um patrulheiro adaptável que usa explosivos, peçonha animal e ataques coordenados com a fera ajudante.'),

-- Ladino
(4, 'Assassinato', 'DPS', 'Um assassino mortal e mestre no uso de venenos que usa adagas para eliminar impiedosamente as vítimas.'),
(4, 'Fora da Lei', 'DPS', 'Um fugitivo inclemente que usa a agilidade e a esperteza para lutar de igual para igual com os inimigos.'),
(4, 'Subterfúgio', 'DPS', 'Um espreitador sombrio que se esconde nas trevas para emboscar e eliminar as vítimas subitamente.'),

-- Sacerdote
(5, 'Disciplina', 'Healer', 'Protege os aliados e cura as feridas deles punindo os inimigos.'),
(5, 'Sagrado', 'Healer', 'Um curador versátil, capaz de reverter dano de grupos e jogadores individuais e até mesmo curar após morrer.'),
(5, 'Sombra', 'DPS', 'Usa a sinistra magia Sombria e a aterrorizante magia de Caos para erradicar inimigos.'),

-- Xamã
(6, 'Elemental', 'DPS', 'Um lançador de feitiços que controla os elementos e as destrutivas forças da natureza.'),
(6, 'Aperfeiçoamento', 'DPS', 'Um guerreiro totêmico que ataca os inimigos com armas imbuídas em poderes elementais.'),
(6, 'Restauração', 'Healer', 'Um curandeiro que invoca espíritos ancestrais e poderes purificantes da água para curar os aliados.'),

-- Mago
(7, 'Arcano', 'DPS', 'Manipula magia Arcana bruta, destruindo inimigos com poder implacável.'),
(7, 'Fogo', 'DPS', 'Concentra a pura essência da magia de Fogo, atacando inimigos com chamas famintas.'),
(7, 'Gélido', 'DPS', 'Congela, imobiliza e estilhaça todos os inimigos com feitiços de Gelo.'),

-- Bruxo
(8, 'Suplício', 'DPS', 'Um mestre na magia de sombras, especializado em feitiços de drenagem e dano periódico.'),
(8, 'Demonologia', 'DPS', 'Um comandante de demônios que deturpa as almas do próprio exército numa força devastadora.'),
(8, 'Destruição', 'DPS', 'Mestre do caos que evoca o fogo para queimar e destruir inimigos.'),

-- Monge
(9, 'Mestre Cervejeiro', 'Tank', 'Um valentão robusto que usa movimentos imprevisíveis e cervejas místicas para evitar danos e proteger aliados.'),
(9, 'Tecelão da Névoa', 'Healer', 'Um curandeiro que domina a arte de manipular as energias vitais, ajudado pela sabedoria da Serpente de Jade.'),
(9, 'Andarilho do Vento', 'DPS', 'Um inigualável mestre das artes marciais que espanca adversários à mão livre.'),

-- Cavaleiro da Morte
(10, 'Sangue', 'Tank', 'Um guardião sombrio que manipula e corrompe energia vital para sobreviver aos ataques inimigos.'),
(10, 'Gélido', 'DPS', 'Um gélido arauto da destruição que canaliza poderes rúnicos e desfere ataques cruéis.'),
(10, 'Profano', 'DPS', 'Mestre da morte e decomposição, capaz de espalhar infecções e controlar lacaios mortos-vivos.'),

-- Caçador de Demônios
(11, 'Devastação', 'DPS', 'Um mestre sombrio das glaives de guerra e do poder destrutivo da magia vil.'),
(11, 'Vingança', 'Tank', 'Abraça o demônio interior para incinerar os inimigos e proteger os aliados.'),

-- Druida
(12, 'Equilíbrio', 'DPS', 'Assume a forma de um poderoso Luniscante e equilibra as magias Arcana e de Natureza para destruir inimigos.'),
(12, 'Feral', 'DPS', 'Assume a forma de um grande felino que causa dano com mordidas e sangramentos.'),
(12, 'Guardião', 'Tank', 'Assume a forma de um grande urso que absorve dano e protege aliados.'),
(12, 'Restauração', 'Healer', 'Canaliza poderosa magia de Natureza para regenerar e revitalizar aliados.');

-- Tabela de combinações favoritas
CREATE TABLE combinacoes_favoritas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    raca_id INT NOT NULL,
    classe_id INT NOT NULL,
    especializacao_id INT NOT NULL,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    nota TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (raca_id) REFERENCES racas(id),
    FOREIGN KEY (classe_id) REFERENCES classes(id),
    FOREIGN KEY (especializacao_id) REFERENCES especializacoes(id)
) ENGINE=InnoDB;

-- Tabela de histórico de randomizações
CREATE TABLE historico_randomizacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    raca_id INT NOT NULL,
    classe_id INT NOT NULL,
    especializacao_id INT NOT NULL,
    data_geracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    parametros TEXT COMMENT 'JSON com os filtros usados',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (raca_id) REFERENCES racas(id),
    FOREIGN KEY (classe_id) REFERENCES classes(id),
    FOREIGN KEY (especializacao_id) REFERENCES especializacoes(id)
) ENGINE=InnoDB;

-- Tabela de restrições raça-classe
CREATE TABLE raca_classe (
    raca_id INT NOT NULL,
    classe_id INT NOT NULL,
    PRIMARY KEY (raca_id, classe_id),
    FOREIGN KEY (raca_id) REFERENCES racas(id),
    FOREIGN KEY (classe_id) REFERENCES classes(id)
) ENGINE=InnoDB;

-- Inserção de combinações raça-classe válidas (exemplos)
INSERT INTO raca_classe (raca_id, classe_id) VALUES
-- Orc (1)
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 7), (1, 8), (1, 9), (1, 11), (1, 12),

-- Tauren (2)
(2, 1), (2, 3), (2, 6), (2, 7), (2, 9), (2, 10), (2, 11), (2, 12),

-- Troll (3)
(3, 1), (3, 3), (3, 4), (3, 5), (3, 6), (3, 7), (3, 8), (3, 9), (3, 10), (3, 11), (3, 12),

-- Morto-Vivo (4)
(4, 1), (4, 3), (4, 4), (4, 5), (4, 6), (4, 7), (4, 8), (4, 9), (4, 10), (4, 11),

-- Elfo Sangrento (5)
(5, 2), (5, 3), (5, 4), (5, 5), (5, 7), (5, 8), (5, 9), (5, 10), (5, 11), (5, 12),

-- Goblin (6)
(6, 1), (6, 3), (6, 4), (6, 5), (6, 6), (6, 7), (6, 8), (6, 9), (6, 11),

-- Humano (7)
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 8), (7, 9), (7, 10), (7, 11), (7, 12),

-- Anão (8)
(8, 1), (8, 2), (8, 3), (8, 4), (8, 5), (8, 6), (8, 7), (8, 8), (8, 9), (8, 10), (8, 11),

-- Elfo Noturno (9)
(9, 1), (9, 3), (9, 4), (9, 5), (9, 6), (9, 7), (9, 8), (9, 9), (9, 10), (9, 11), (9, 12),

-- Gnomo (10)
(10, 1), (10, 3), (10, 4), (10, 5), (10, 6), (10, 7), (10, 8), (10, 9), (10, 11),

-- Draenei (11)
(11, 1), (11, 2), (11, 3), (11, 5), (11, 6), (11, 7), (11, 9), (11, 10), (11, 11), (11, 12),

-- Worgen (12)
(12, 1), (12, 3), (12, 4), (12, 5), (12, 6), (12, 7), (12, 8), (12, 9), (12, 10), (12, 11), (12, 12);

-- View para combinações válidas
CREATE VIEW vw_combinacoes_validas AS
SELECT 
    r.id AS raca_id,
    r.nome AS raca,
    r.faccao_id,
    f.nome AS faccao,
    c.id AS classe_id,
    c.nome AS classe,
    c.tipo_combate,
    e.id AS especializacao_id,
    e.nome AS especializacao,
    e.funcao
FROM 
    racas r
    JOIN faccoes f ON r.faccao_id = f.id
    JOIN raca_classe rc ON r.id = rc.raca_id
    JOIN classes c ON rc.classe_id = c.id
    JOIN especializacoes e ON c.id = e.classe_id
WHERE 
    r.ativa = TRUE;

-- Stored procedure para randomização
DELIMITER //

CREATE OR REPLACE PROCEDURE sp_gerar_personagem(
    IN p_usuario_id INT,
    IN p_faccao CHAR(1),
    IN p_funcao VARCHAR(10),
    IN p_tipo_combate VARCHAR(10)
)
BEGIN
    DECLARE v_raca_id INT;
    DECLARE v_classe_id INT;
    DECLARE v_especializacao_id INT;
    DECLARE v_count INT;
    
    -- Verifica e obtém raça válida
    IF p_faccao IS NULL THEN
        SELECT COUNT(*) INTO v_count FROM racas WHERE ativa = TRUE;
        IF v_count = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhuma raça disponível';
        END IF;
        
        SELECT id INTO v_raca_id FROM racas 
        WHERE ativa = TRUE 
        ORDER BY RAND() LIMIT 1;
    ELSE
        SELECT COUNT(*) INTO v_count FROM racas 
        WHERE faccao_id = p_faccao AND ativa = TRUE;
        IF v_count = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhuma raça disponível para a facção selecionada';
        END IF;
        
        SELECT id INTO v_raca_id FROM racas 
        WHERE faccao_id = p_faccao AND ativa = TRUE 
        ORDER BY RAND() LIMIT 1;
    END IF;
    
    -- Verifica e obtém classe válida
    SELECT COUNT(*) INTO v_count FROM raca_classe 
    JOIN classes c ON c.id = raca_classe.classe_id
    JOIN especializacoes e ON e.classe_id = c.id
    WHERE raca_id = v_raca_id
    AND (p_funcao IS NULL OR e.funcao = p_funcao)
    AND (p_tipo_combate IS NULL OR c.tipo_combate = p_tipo_combate);
    
    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhuma combinação válida encontrada com os filtros selecionados';
    END IF;
    
    SELECT c.id INTO v_classe_id
    FROM classes c
    JOIN raca_classe rc ON c.id = rc.classe_id
    JOIN especializacoes e ON c.id = e.classe_id
    WHERE rc.raca_id = v_raca_id
    AND (p_funcao IS NULL OR e.funcao = p_funcao)
    AND (p_tipo_combate IS NULL OR c.tipo_combate = p_tipo_combate)
    GROUP BY c.id
    ORDER BY RAND()
    LIMIT 1;
    
    -- Obtém especialização
    IF p_funcao IS NULL THEN
        SELECT id INTO v_especializacao_id 
        FROM especializacoes 
        WHERE classe_id = v_classe_id 
        ORDER BY RAND() 
        LIMIT 1;
    ELSE
        SELECT id INTO v_especializacao_id 
        FROM especializacoes 
        WHERE classe_id = v_classe_id AND funcao = p_funcao
        ORDER BY RAND() 
        LIMIT 1;
    END IF;
    
    -- Registra no histórico (apenas se usuario_id não for NULL)
    IF p_usuario_id IS NOT NULL THEN
        INSERT INTO historico_randomizacoes (usuario_id, raca_id, classe_id, especializacao_id, parametros)
        VALUES (p_usuario_id, v_raca_id, v_classe_id, v_especializacao_id, 
                CONCAT('{"faccao":"', IFNULL(p_faccao, 'aleatorio'), '", "funcao":"', IFNULL(p_funcao, 'aleatorio'), '", "tipo_combate":"', IFNULL(p_tipo_combate, 'aleatorio'), '"}'));
    END IF;
    
    -- Retorna o resultado
    SELECT 
        r.id AS raca_id,
        r.nome AS raca,
        f.nome AS faccao,
        c.id AS classe_id,
        c.nome AS classe,
        c.tipo_combate,
        e.id AS especializacao_id,
        e.nome AS especializacao,
        e.funcao
    FROM 
        racas r
        JOIN faccoes f ON r.faccao_id = f.id
        JOIN classes c ON c.id = v_classe_id
        JOIN especializacoes e ON e.id = v_especializacao_id
    WHERE 
        r.id = v_raca_id;
END //

DELIMITER ;
-- Criar usuário admin padrão
INSERT INTO usuarios (nome_usuario, email, senha_hash) 
VALUES ('admin', 'admin@wowrandomizer.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'); -- senha: password

SHOW PROCEDURE STATUS WHERE Db = 'wow_randomizer';

select * from especializacoes;