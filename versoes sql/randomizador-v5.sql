-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 09, 2025 at 03:21 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `wow_randomizer`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_personagem` (IN `p_usuario_id` INT, IN `p_faccao` CHAR(1), IN `p_funcao` VARCHAR(20), IN `p_tipo_combate` VARCHAR(20))   BEGIN
    DECLARE v_raca_id INT;
    DECLARE v_classe_id INT;
    DECLARE v_especializacao_id INT;
    DECLARE v_finalizado BOOL DEFAULT FALSE;

    -- Loop para garantir que encontre uma combinação válida
    REPEAT
        -- 🔹 Selecionar uma raça válida, considerando facção se informado
        SELECT r.id INTO v_raca_id
        FROM racas r
        WHERE (p_faccao IS NULL OR r.faccao_id = p_faccao)
          AND r.ativa = 1
        ORDER BY RAND()
        LIMIT 1;

        -- 🔸 Selecionar uma classe permitida para a raça
        SELECT rc.classe_id INTO v_classe_id
        FROM raca_classe rc
        WHERE rc.raca_id = v_raca_id
        ORDER BY RAND()
        LIMIT 1;

        -- 🔸 Selecionar uma especialização que combina com a função e tipo de combate (se informados)
        SELECT e.id INTO v_especializacao_id
        FROM especializacoes e
        JOIN classes c ON c.id = e.classe_id
        WHERE e.classe_id = v_classe_id
          AND (p_funcao IS NULL OR e.funcao = p_funcao)
          AND (p_tipo_combate IS NULL OR c.tipo_combate = p_tipo_combate)
        ORDER BY RAND()
        LIMIT 1;

        -- 🔥 Verificar se encontrou especialização válida
        IF v_especializacao_id IS NOT NULL THEN
            SET v_finalizado = TRUE;
        END IF;

    UNTIL v_finalizado END REPEAT;

    -- 🔸 Retornar as informações completas
    SELECT 
        r.id AS raca_id,
        r.nome AS raca,
        r.faccao_id AS faccao,
        c.id AS classe_id,
        c.nome AS classe,
        c.tipo_combate,
        c.cor_hex,
        e.id AS especializacao_id,
        e.nome AS especializacao,
        e.funcao,
        e.descricao
    FROM racas r
    JOIN raca_classe rc ON rc.raca_id = r.id AND rc.classe_id = v_classe_id
    JOIN classes c ON c.id = v_classe_id
    JOIN especializacoes e ON e.id = v_especializacao_id
    WHERE r.id = v_raca_id
    LIMIT 1;

    -- 🔸 Inserir no histórico
    INSERT INTO historico_randomizacoes (
        usuario_id, raca_id, raca, classe_id, classe, 
        especializacao_id, especializacao, funcao, tipo_combate, faccao, data_geracao
    )
    VALUES (
        p_usuario_id, v_raca_id, 
        (SELECT nome FROM racas WHERE id = v_raca_id),
        v_classe_id, 
        (SELECT nome FROM classes WHERE id = v_classe_id),
        v_especializacao_id, 
        (SELECT nome FROM especializacoes WHERE id = v_especializacao_id),
        (SELECT funcao FROM especializacoes WHERE id = v_especializacao_id),
        (SELECT tipo_combate FROM classes WHERE id = v_classe_id),
        (SELECT faccao_id FROM racas WHERE id = v_raca_id),
        NOW()
    );
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `descricao` text DEFAULT NULL,
  `tipo_combate` enum('Melee','Ranged','Híbrido') NOT NULL,
  `cor_hex` varchar(7) DEFAULT '#FFFFFF',
  `icone` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`id`, `nome`, `descricao`, `tipo_combate`, `cor_hex`, `icone`) VALUES
(1, 'Guerreiro', 'Mestres do combate com armas', 'Melee', '#C79C6E', 'class_warrior'),
(2, 'Paladino', 'Cavaleiros sagrados da luz', 'Híbrido', '#F58CBA', 'class_paladin'),
(3, 'Caçador', 'Especialistas em armas à distância', 'Ranged', '#ABD473', 'class_hunter'),
(4, 'Ladino', 'Mestres do combate furtivo', 'Melee', '#FFF569', 'class_rogue'),
(5, 'Sacerdote', 'Servos das forças divinas e sombrias', 'Ranged', '#FFFFFF', 'class_priest'),
(6, 'Xamã', 'Invocadores dos elementos', 'Híbrido', '#0070DE', 'class_shaman'),
(7, 'Mago', 'Mestres das artes arcanas', 'Ranged', '#69CCF0', 'class_mage'),
(8, 'Bruxo', 'Conjuradores de magias sombrias', 'Ranged', '#9482C9', 'class_warlock'),
(9, 'Monge', 'Mestres das artes marciais', 'Híbrido', '#00FF96', 'class_monk'),
(10, 'Druida', 'Guardiões da natureza versáteis', 'Híbrido', '#FF7D0A', 'class_druid'),
(11, 'Cavaleiro da Morte', 'Guerreiros runicos amaldiçoados', 'Melee', '#C41F3B', 'class_deathknight'),
(12, 'Caçador de Demônios', 'Elfos transformados por magia vil', 'Melee', '#A330C9', 'class_demonhunter');

-- --------------------------------------------------------

--
-- Table structure for table `combinacoes_favoritas`
--

CREATE TABLE `combinacoes_favoritas` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `raca_id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `especializacao_id` int(11) NOT NULL,
  `data_criacao` datetime DEFAULT current_timestamp(),
  `nota` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `especializacoes`
--

CREATE TABLE `especializacoes` (
  `id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `funcao` enum('DPS','Tank','Healer') NOT NULL,
  `descricao` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `especializacoes`
--

INSERT INTO `especializacoes` (`id`, `classe_id`, `nome`, `funcao`, `descricao`) VALUES
(1, 1, 'Armas', 'DPS', 'Um experiente mestre de armas, que emprega mobilidade e ataques poderosos para destroçar os inimigos.'),
(2, 1, 'Fúria', 'DPS', 'Um berserker furioso empunhando duas armas que desfere uma torrente de ataques para fazer picadinho dos oponentes.'),
(3, 1, 'Proteção', 'Tank', 'Um defensor implacável que usa um escudo para proteger a si mesmo e também os aliados.'),
(4, 2, 'Sagrado', 'Healer', 'Invoca o poder da Luz para proteger e curar aliados, e derrotar o mal nos cantos mais sombrios do mundo.'),
(5, 2, 'Proteção', 'Tank', 'Utiliza magia Sagrada para se proteger e defender os aliados.'),
(6, 2, 'Retribuição', 'DPS', 'Um cruzado íntegro e justo, que julga e pune os oponentes com armas e magia Sagrada.'),
(7, 3, 'Domínio das Feras', 'DPS', 'Um mestre da vida selvagem, capaz de domar uma enorme variedade de feras para ajudá-lo em combate.'),
(8, 3, 'Precisão', 'DPS', 'Um exímio atirador, mestre em abater os inimigos à distância.'),
(9, 3, 'Sobrevivência', 'DPS', 'Um patrulheiro adaptável que usa explosivos, peçonha animal e ataques coordenados com a fera ajudante.'),
(10, 4, 'Assassinato', 'DPS', 'Um assassino mortal e mestre no uso de venenos que usa adagas para eliminar impiedosamente as vítimas.'),
(11, 4, 'Fora da Lei', 'DPS', 'Um fugitivo inclemente que usa a agilidade e a esperteza para lutar de igual para igual com os inimigos.'),
(12, 4, 'Subterfúgio', 'DPS', 'Um espreitador sombrio que se esconde nas trevas para emboscar e eliminar as vítimas subitamente.'),
(13, 5, 'Disciplina', 'Healer', 'Protege os aliados e cura as feridas deles punindo os inimigos.'),
(14, 5, 'Sagrado', 'Healer', 'Um curador versátil, capaz de reverter dano de grupos e jogadores individuais e até mesmo curar após morrer.'),
(15, 5, 'Sombra', 'DPS', 'Usa a sinistra magia Sombria e a aterrorizante magia de Caos para erradicar inimigos.'),
(16, 6, 'Elemental', 'DPS', 'Um lançador de feitiços que controla os elementos e as destrutivas forças da natureza.'),
(17, 6, 'Aperfeiçoamento', 'DPS', 'Um guerreiro totêmico que ataca os inimigos com armas imbuídas em poderes elementais.'),
(18, 6, 'Restauração', 'Healer', 'Um curandeiro que invoca espíritos ancestrais e poderes purificantes da água para curar os aliados.'),
(19, 7, 'Arcano', 'DPS', 'Manipula magia Arcana bruta, destruindo inimigos com poder implacável.'),
(20, 7, 'Fogo', 'DPS', 'Concentra a pura essência da magia de Fogo, atacando inimigos com chamas famintas.'),
(21, 7, 'Gélido', 'DPS', 'Congela, imobiliza e estilhaça todos os inimigos com feitiços de Gelo.'),
(22, 8, 'Suplício', 'DPS', 'Um mestre na magia de sombras, especializado em feitiços de drenagem e dano periódico.'),
(23, 8, 'Demonologia', 'DPS', 'Um comandante de demônios que deturpa as almas do próprio exército numa força devastadora.'),
(24, 8, 'Destruição', 'DPS', 'Mestre do caos que evoca o fogo para queimar e destruir inimigos.'),
(25, 9, 'Mestre Cervejeiro', 'Tank', 'Um valentão robusto que usa movimentos imprevisíveis e cervejas místicas para evitar danos e proteger aliados.'),
(26, 9, 'Tecelão da Névoa', 'Healer', 'Um curandeiro que domina a arte de manipular as energias vitais, ajudado pela sabedoria da Serpente de Jade.'),
(27, 9, 'Andarilho do Vento', 'DPS', 'Um inigualável mestre das artes marciais que espanca adversários à mão livre.'),
(28, 11, 'Sangue', 'Tank', 'Um guardião sombrio que manipula e corrompe energia vital para sobreviver aos ataques inimigos.'),
(29, 11, 'Gélido', 'DPS', 'Um gélido arauto da destruição que canaliza poderes rúnicos e desfere ataques cruéis.'),
(30, 11, 'Profano', 'DPS', 'Mestre da morte e decomposição, capaz de espalhar infecções e controlar lacaios mortos-vivos.'),
(31, 12, 'Devastação', 'DPS', 'Um mestre sombrio das glaives de guerra e do poder destrutivo da magia vil.'),
(32, 12, 'Vingança', 'Tank', 'Abraça o demônio interior para incinerar os inimigos e proteger os aliados.'),
(33, 10, 'Equilíbrio', 'DPS', 'Assume a forma de um poderoso Luniscante e equilibra as magias Arcana e de Natureza para destruir inimigos.'),
(34, 10, 'Feral', 'DPS', 'Assume a forma de um grande felino que causa dano com mordidas e sangramentos.'),
(35, 10, 'Guardião', 'Tank', 'Assume a forma de um grande urso que absorve dano e protege aliados.'),
(36, 10, 'Restauração', 'Healer', 'Canaliza poderosa magia de Natureza para regenerar e revitalizar aliados.');

-- --------------------------------------------------------

--
-- Table structure for table `faccoes`
--

CREATE TABLE `faccoes` (
  `id` char(1) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `descricao` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `faccoes`
--

INSERT INTO `faccoes` (`id`, `nome`, `descricao`) VALUES
('A', 'Aliança', 'Facção composta por humanos, anões, elfos noturnos, gnomes, draeneis e worgens'),
('H', 'Horda', 'Facção composta por orcs, trolls, taurens, mortos-vivos, elfos sangrentos e goblins');

-- --------------------------------------------------------

--
-- Table structure for table `historico_randomizacoes`
--

CREATE TABLE `historico_randomizacoes` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `raca_id` int(11) NOT NULL,
  `raca` varchar(50) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `classe` varchar(50) NOT NULL,
  `especializacao_id` int(11) NOT NULL,
  `especializacao` varchar(50) NOT NULL,
  `funcao` varchar(20) NOT NULL,
  `tipo_combate` varchar(20) NOT NULL,
  `faccao` varchar(20) NOT NULL,
  `data_geracao` datetime DEFAULT current_timestamp(),
  `parametros` text DEFAULT NULL COMMENT 'JSON com os filtros usados'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `racas`
--

CREATE TABLE `racas` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `faccao_id` char(1) NOT NULL,
  `descricao` text DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT 1,
  `faccao` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `racas`
--

INSERT INTO `racas` (`id`, `nome`, `faccao_id`, `descricao`, `ativa`, `faccao`) VALUES
(1, 'Orc', 'H', 'Guerreiros brutais com sede de batalha', 1, ''),
(2, 'Tauren', 'H', 'Poderosos seres bovinos de grande força física', 1, ''),
(3, 'Troll', 'H', 'Povo espiritual com grande agilidade', 1, ''),
(4, 'Renegado', 'H', 'Rejeitados que escaparam do controle do Lich Rei', 1, ''),
(5, 'Elfo Sangrento', 'H', 'Ex-elfos nobres corrompidos por magia arcana', 1, ''),
(6, 'Goblin', 'H', 'Engenheiros mercenários ágeis e astutos', 1, ''),
(7, 'Humano', 'A', 'Versáteis e adaptáveis, com espírito resiliente', 1, ''),
(8, 'Anão', 'A', 'Robustos e resistentes, mestres em combate corpo a corpo', 1, ''),
(9, 'Elfo Noturno', 'A', 'Seres místicos conectados à natureza', 1, ''),
(10, 'Gnomo', 'A', 'Pequenos e inteligentes, especialistas em tecnologia', 1, ''),
(11, 'Draenei', 'A', 'Nobres exilados com conexão divina', 1, ''),
(12, 'Worgen', 'A', 'Humanos amaldiçoados com forma lupina', 1, '');

-- --------------------------------------------------------

--
-- Table structure for table `raca_classe`
--

CREATE TABLE `raca_classe` (
  `raca_id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `raca_classe`
--

INSERT INTO `raca_classe` (`raca_id`, `classe_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 7),
(1, 8),
(1, 9),
(1, 11),
(2, 1),
(2, 3),
(2, 6),
(2, 7),
(2, 9),
(2, 10),
(2, 11),
(3, 1),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(4, 1),
(4, 3),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 11),
(5, 2),
(5, 3),
(5, 4),
(5, 5),
(5, 7),
(5, 8),
(5, 9),
(5, 11),
(5, 12),
(6, 1),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(6, 7),
(6, 8),
(6, 9),
(6, 11),
(7, 1),
(7, 2),
(7, 3),
(7, 4),
(7, 5),
(7, 6),
(7, 7),
(7, 8),
(7, 9),
(7, 11),
(8, 1),
(8, 2),
(8, 3),
(8, 4),
(8, 5),
(8, 6),
(8, 7),
(8, 8),
(8, 9),
(8, 11),
(9, 1),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(9, 7),
(9, 8),
(9, 9),
(9, 10),
(9, 11),
(9, 12),
(10, 1),
(10, 3),
(10, 4),
(10, 5),
(10, 6),
(10, 7),
(10, 8),
(10, 9),
(10, 11),
(11, 1),
(11, 2),
(11, 3),
(11, 5),
(11, 6),
(11, 7),
(11, 9),
(11, 11),
(12, 1),
(12, 3),
(12, 4),
(12, 5),
(12, 6),
(12, 7),
(12, 8),
(12, 9),
(12, 10),
(12, 11);

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome_usuario` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `data_cadastro` datetime DEFAULT current_timestamp(),
  `ultimo_login` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome_usuario`, `email`, `senha_hash`, `data_cadastro`, `ultimo_login`, `ativo`) VALUES
(4, 'marcinha', 'marcinha@gmail.com', '$2y$10$Y66plSuy1x80SsS.j8TaAuiyy0G3v/zwYLDLGK7UTdmyqbSepRRnS', '2025-06-09 10:02:22', NULL, 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_combinacoes_validas`
-- (See below for the actual view)
--
CREATE TABLE `vw_combinacoes_validas` (
`raca_id` int(11)
,`raca` varchar(50)
,`faccao_id` char(1)
,`faccao` varchar(20)
,`classe_id` int(11)
,`classe` varchar(50)
,`tipo_combate` enum('Melee','Ranged','Híbrido')
,`especializacao_id` int(11)
,`especializacao` varchar(100)
,`funcao` enum('DPS','Tank','Healer')
);

-- --------------------------------------------------------

--
-- Structure for view `vw_combinacoes_validas`
--
DROP TABLE IF EXISTS `vw_combinacoes_validas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_combinacoes_validas`  AS SELECT `r`.`id` AS `raca_id`, `r`.`nome` AS `raca`, `r`.`faccao_id` AS `faccao_id`, `f`.`nome` AS `faccao`, `c`.`id` AS `classe_id`, `c`.`nome` AS `classe`, `c`.`tipo_combate` AS `tipo_combate`, `e`.`id` AS `especializacao_id`, `e`.`nome` AS `especializacao`, `e`.`funcao` AS `funcao` FROM ((((`racas` `r` join `faccoes` `f` on(`r`.`faccao_id` = `f`.`id`)) join `raca_classe` `rc` on(`r`.`id` = `rc`.`raca_id`)) join `classes` `c` on(`rc`.`classe_id` = `c`.`id`)) join `especializacoes` `e` on(`c`.`id` = `e`.`classe_id`)) WHERE `r`.`ativa` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `raca_id` (`raca_id`),
  ADD KEY `classe_id` (`classe_id`),
  ADD KEY `especializacao_id` (`especializacao_id`);

--
-- Indexes for table `especializacoes`
--
ALTER TABLE `especializacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `classe_id` (`classe_id`);

--
-- Indexes for table `faccoes`
--
ALTER TABLE `faccoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `raca_id` (`raca_id`),
  ADD KEY `classe_id` (`classe_id`),
  ADD KEY `especializacao_id` (`especializacao_id`);

--
-- Indexes for table `racas`
--
ALTER TABLE `racas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faccao_id` (`faccao_id`);

--
-- Indexes for table `raca_classe`
--
ALTER TABLE `raca_classe`
  ADD PRIMARY KEY (`raca_id`,`classe_id`),
  ADD KEY `classe_id` (`classe_id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome_usuario` (`nome_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `especializacoes`
--
ALTER TABLE `especializacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=382;

--
-- AUTO_INCREMENT for table `racas`
--
ALTER TABLE `racas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_2` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_3` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_4` FOREIGN KEY (`especializacao_id`) REFERENCES `especializacoes` (`id`);

--
-- Constraints for table `especializacoes`
--
ALTER TABLE `especializacoes`
  ADD CONSTRAINT `especializacoes_ibfk_1` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`);

--
-- Constraints for table `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  ADD CONSTRAINT `historico_randomizacoes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_2` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_3` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_4` FOREIGN KEY (`especializacao_id`) REFERENCES `especializacoes` (`id`);

--
-- Constraints for table `racas`
--
ALTER TABLE `racas`
  ADD CONSTRAINT `racas_ibfk_1` FOREIGN KEY (`faccao_id`) REFERENCES `faccoes` (`id`);

--
-- Constraints for table `raca_classe`
--
ALTER TABLE `raca_classe`
  ADD CONSTRAINT `raca_classe_ibfk_1` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `raca_classe_ibfk_2` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
