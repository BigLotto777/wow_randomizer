-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 20/05/2025 às 03:51
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `wow_randomizer`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_gerar_personagem` (IN `p_usuario_id` INT, IN `p_faccao` VARCHAR(20), IN `p_funcao` VARCHAR(10), IN `p_tipo_combate` VARCHAR(10))   BEGIN
    SELECT 
        r.raca_id,
        r.raca,
        r.faccao,
        r.classe_id,
        r.classe,
        r.tipo_combate,
        c.cor_hex,
        r.especializacao_id,
        r.especializacao,
        r.funcao,
        e.descricao
    FROM vw_combinacoes_validas r
    JOIN classes c ON c.id = r.classe_id
    JOIN especializacoes e ON e.id = r.especializacao_id
    WHERE
        (p_faccao IS NULL OR r.faccao = p_faccao)
        AND (p_funcao IS NULL OR r.funcao = p_funcao)
        AND (p_tipo_combate IS NULL OR r.tipo_combate = p_tipo_combate)
    ORDER BY RAND()
    LIMIT 10;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `classes`
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
-- Despejando dados para a tabela `classes`
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
-- Estrutura para tabela `combinacoes_favoritas`
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
-- Estrutura para tabela `especializacoes`
--

CREATE TABLE `especializacoes` (
  `id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `funcao` enum('DPS','Tank','Healer') NOT NULL,
  `descricao` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `especializacoes`
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
-- Estrutura para tabela `faccoes`
--

CREATE TABLE `faccoes` (
  `id` char(1) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `descricao` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `faccoes`
--

INSERT INTO `faccoes` (`id`, `nome`, `descricao`) VALUES
('A', 'Aliança', 'Facção composta por humanos, anões, elfos noturnos, gnomes, draeneis e worgens'),
('H', 'Horda', 'Facção composta por orcs, trolls, taurens, mortos-vivos, elfos sangrentos e goblins');

-- --------------------------------------------------------

--
-- Estrutura para tabela `historico_randomizacoes`
--

CREATE TABLE `historico_randomizacoes` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `raca_id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL,
  `especializacao_id` int(11) NOT NULL,
  `data_geracao` datetime DEFAULT current_timestamp(),
  `parametros` text DEFAULT NULL COMMENT 'JSON com os filtros usados'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `historico_randomizacoes`
--

INSERT INTO `historico_randomizacoes` (`id`, `usuario_id`, `raca_id`, `classe_id`, `especializacao_id`, `data_geracao`, `parametros`) VALUES
(1, NULL, 3, 3, 7, '2025-05-19 11:48:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(2, NULL, 2, 11, 31, '2025-05-19 11:52:59', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(3, NULL, 2, 11, 31, '2025-05-19 11:58:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(4, NULL, 6, 1, 3, '2025-05-19 11:59:09', '{\"faccao\":\"H\", \"funcao\":\"Tank\", \"tipo_combate\":\"aleatorio\"}'),
(5, NULL, 3, 12, 35, '2025-05-19 12:15:07', '{\"faccao\":\"H\", \"funcao\":\"Tank\", \"tipo_combate\":\"aleatorio\"}'),
(6, NULL, 1, 8, 22, '2025-05-19 12:15:31', '{\"faccao\":\"H\", \"funcao\":\"DPS\", \"tipo_combate\":\"aleatorio\"}'),
(7, NULL, 4, 5, 15, '2025-05-19 12:18:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(8, NULL, 4, 4, 10, '2025-05-19 12:23:23', '{\"faccao\":\"H\", \"funcao\":\"DPS\", \"tipo_combate\":\"aleatorio\"}'),
(9, NULL, 1, 8, 23, '2025-05-19 12:24:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(10, NULL, 8, 2, 5, '2025-05-19 12:24:20', '{\"faccao\":\"A\", \"funcao\":\"Tank\", \"tipo_combate\":\"aleatorio\"}'),
(11, NULL, 7, 10, 29, '2025-05-19 12:24:37', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(12, NULL, 11, 11, 32, '2025-05-19 12:24:41', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(13, NULL, 9, 1, 2, '2025-05-19 12:24:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"Melee\"}'),
(14, NULL, 3, 3, 7, '2025-05-19 12:24:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"Ranged\"}'),
(15, NULL, 3, 9, 27, '2025-05-19 12:24:57', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"Híbrido\"}'),
(16, NULL, 5, 8, 23, '2025-05-19 12:25:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(17, NULL, 3, 5, 14, '2025-05-19 12:25:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(18, NULL, 12, 5, 13, '2025-05-19 12:25:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(19, NULL, 6, 1, 3, '2025-05-19 12:25:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(20, NULL, 9, 5, 13, '2025-05-19 12:25:05', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(21, NULL, 12, 10, 29, '2025-05-19 12:29:29', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(22, NULL, 11, 9, 27, '2025-05-19 12:29:32', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(23, NULL, 12, 1, 3, '2025-05-19 13:14:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(24, NULL, 10, 3, 8, '2025-05-19 13:14:06', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(25, NULL, 7, 11, 31, '2025-05-19 13:14:08', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(26, NULL, 3, 11, 31, '2025-05-19 13:14:11', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(27, NULL, 2, 9, 26, '2025-05-19 13:14:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(28, NULL, 6, 4, 11, '2025-05-19 13:26:04', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(29, NULL, 1, 8, 24, '2025-05-19 13:26:09', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(30, NULL, 5, 10, 29, '2025-05-19 13:26:10', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(31, NULL, 1, 5, 13, '2025-05-19 13:26:11', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(32, NULL, 2, 6, 16, '2025-05-19 13:36:14', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(33, NULL, 12, 12, 35, '2025-05-19 13:37:14', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(34, NULL, 3, 9, 25, '2025-05-19 13:37:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(35, NULL, 2, 12, 36, '2025-05-19 13:37:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(36, NULL, 12, 8, 22, '2025-05-19 13:37:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(37, NULL, 10, 3, 9, '2025-05-19 13:37:59', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(38, NULL, 3, 6, 18, '2025-05-19 13:38:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(39, NULL, 10, 7, 20, '2025-05-19 13:38:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(40, NULL, 7, 6, 16, '2025-05-19 13:38:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(41, NULL, 4, 3, 8, '2025-05-19 13:38:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(42, NULL, 1, 4, 11, '2025-05-19 13:38:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(43, NULL, 10, 7, 21, '2025-05-19 13:38:04', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(44, NULL, 2, 12, 34, '2025-05-19 13:38:05', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(45, NULL, 9, 9, 27, '2025-05-19 13:43:50', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(46, NULL, 8, 7, 19, '2025-05-19 13:52:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(47, NULL, 6, 6, 18, '2025-05-19 13:52:04', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(48, NULL, 12, 8, 23, '2025-05-19 13:52:04', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(49, NULL, 5, 3, 8, '2025-05-19 13:52:06', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(50, NULL, 5, 3, 8, '2025-05-19 13:52:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(51, NULL, 3, 4, 11, '2025-05-19 13:52:19', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(52, NULL, 1, 5, 14, '2025-05-19 13:52:19', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(53, NULL, 10, 8, 22, '2025-05-19 13:52:20', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(54, NULL, 6, 5, 15, '2025-05-19 13:52:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(55, NULL, 10, 3, 8, '2025-05-19 13:52:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(56, NULL, 9, 4, 12, '2025-05-19 13:52:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(57, NULL, 2, 1, 2, '2025-05-19 13:52:22', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(58, NULL, 3, 5, 13, '2025-05-19 13:52:22', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(59, NULL, 10, 6, 17, '2025-05-19 13:52:23', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(60, NULL, 4, 1, 3, '2025-05-19 13:52:24', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(61, NULL, 5, 9, 26, '2025-05-19 13:52:24', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(62, NULL, 8, 11, 31, '2025-05-19 13:52:25', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(63, NULL, 6, 8, 24, '2025-05-19 13:52:25', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(64, NULL, 6, 3, 7, '2025-05-19 13:52:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(65, NULL, 4, 3, 9, '2025-05-19 13:52:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(66, NULL, 2, 11, 32, '2025-05-19 13:52:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(67, NULL, 7, 1, 2, '2025-05-19 13:52:29', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(68, NULL, 8, 1, 3, '2025-05-19 13:52:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(69, NULL, 12, 4, 11, '2025-05-19 13:52:31', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(70, NULL, 12, 11, 32, '2025-05-19 13:52:58', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(71, NULL, 11, 7, 19, '2025-05-19 13:53:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(72, NULL, 7, 1, 1, '2025-05-19 13:53:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(73, NULL, 5, 11, 32, '2025-05-19 13:53:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(74, NULL, 3, 4, 11, '2025-05-19 13:53:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(75, NULL, 9, 12, 35, '2025-05-19 13:53:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(76, NULL, 2, 12, 33, '2025-05-19 13:58:11', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(77, NULL, 7, 4, 11, '2025-05-19 14:04:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(78, NULL, 5, 7, 21, '2025-05-19 14:04:10', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(79, NULL, 1, 9, 26, '2025-05-19 14:04:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(80, NULL, 3, 1, 3, '2025-05-19 14:04:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(81, NULL, 11, 9, 26, '2025-05-19 14:14:33', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(82, NULL, 11, 5, 13, '2025-05-19 14:36:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(83, NULL, 8, 11, 32, '2025-05-19 14:37:33', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(84, NULL, 11, 2, 4, '2025-05-19 14:38:47', '{\"faccao\":\"A\", \"funcao\":\"Healer\", \"tipo_combate\":\"aleatorio\"}'),
(85, NULL, 11, 9, 26, '2025-05-19 14:38:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(86, NULL, 9, 8, 24, '2025-05-19 14:39:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(87, NULL, 3, 8, 24, '2025-05-19 16:42:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(88, NULL, 10, 3, 7, '2025-05-19 16:47:32', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(89, NULL, 6, 1, 1, '2025-05-19 16:47:40', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(90, NULL, 3, 1, 3, '2025-05-19 16:50:33', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(91, NULL, 4, 4, 12, '2025-05-19 16:51:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(92, NULL, 10, 8, 24, '2025-05-19 16:51:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(93, NULL, 5, 4, 12, '2025-05-19 16:51:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(94, NULL, 5, 4, 12, '2025-05-19 16:51:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(95, NULL, 2, 3, 7, '2025-05-19 16:51:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(96, NULL, 4, 9, 25, '2025-05-19 16:51:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(97, NULL, 3, 1, 1, '2025-05-19 16:51:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(98, NULL, 2, 1, 2, '2025-05-19 16:51:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(99, NULL, 11, 6, 16, '2025-05-19 16:51:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(100, NULL, 2, 7, 21, '2025-05-19 16:51:19', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(101, NULL, 9, 4, 11, '2025-05-19 16:51:20', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(102, NULL, 7, 9, 25, '2025-05-19 16:51:20', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(103, NULL, 3, 7, 19, '2025-05-19 16:51:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(104, NULL, 3, 9, 27, '2025-05-19 16:55:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(105, NULL, 12, 9, 25, '2025-05-19 16:55:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(106, NULL, 4, 6, 17, '2025-05-19 16:55:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(107, NULL, 2, 12, 35, '2025-05-19 16:55:19', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(108, NULL, 4, 1, 3, '2025-05-19 16:55:20', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(109, NULL, 1, 9, 27, '2025-05-19 16:55:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(110, NULL, 2, 11, 32, '2025-05-19 16:55:22', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(111, NULL, 8, 7, 19, '2025-05-19 16:57:58', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(112, NULL, 8, 9, 26, '2025-05-19 16:58:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(113, NULL, 8, 8, 24, '2025-05-19 16:59:34', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(114, NULL, 12, 11, 32, '2025-05-19 16:59:35', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(115, NULL, 8, 2, 4, '2025-05-19 16:59:36', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(116, NULL, 2, 6, 17, '2025-05-19 16:59:36', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(117, NULL, 6, 3, 9, '2025-05-19 16:59:36', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(118, NULL, 9, 8, 24, '2025-05-19 16:59:37', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(119, NULL, 2, 1, 1, '2025-05-19 17:02:36', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(120, NULL, 4, 9, 25, '2025-05-19 17:02:37', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(121, NULL, 10, 1, 2, '2025-05-19 17:02:38', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(122, NULL, 9, 6, 18, '2025-05-19 17:02:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(123, NULL, 6, 1, 1, '2025-05-19 17:03:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(124, NULL, 11, 12, 33, '2025-05-19 17:03:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(125, NULL, 8, 1, 3, '2025-05-19 17:03:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(126, NULL, 3, 6, 16, '2025-05-19 17:03:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(127, NULL, 4, 5, 13, '2025-05-19 17:03:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(128, NULL, 1, 5, 14, '2025-05-19 17:05:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(129, NULL, 8, 3, 8, '2025-05-19 17:05:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(130, NULL, 11, 11, 32, '2025-05-19 17:05:50', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(131, NULL, 3, 3, 9, '2025-05-19 17:05:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(132, NULL, 1, 3, 9, '2025-05-19 17:05:53', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(133, NULL, 7, 7, 20, '2025-05-19 17:07:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(134, NULL, 12, 10, 29, '2025-05-19 17:07:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(135, NULL, 11, 10, 29, '2025-05-19 17:07:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(136, NULL, 10, 7, 21, '2025-05-19 17:07:53', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(137, NULL, 11, 6, 16, '2025-05-19 17:07:54', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(138, NULL, 4, 10, 30, '2025-05-19 17:07:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(139, NULL, 6, 9, 25, '2025-05-19 17:07:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(140, NULL, 7, 11, 31, '2025-05-19 17:13:28', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(141, NULL, 7, 2, 4, '2025-05-19 17:13:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(142, NULL, 12, 7, 20, '2025-05-19 17:13:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(143, NULL, 6, 4, 10, '2025-05-19 17:14:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(144, NULL, 9, 10, 29, '2025-05-19 17:14:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(145, NULL, 8, 7, 19, '2025-05-19 17:18:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(146, NULL, 7, 5, 14, '2025-05-19 17:18:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(147, NULL, 6, 11, 31, '2025-05-19 17:18:04', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(148, NULL, 5, 3, 7, '2025-05-19 17:18:05', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(149, NULL, 1, 11, 32, '2025-05-19 17:18:05', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(150, NULL, 5, 4, 10, '2025-05-19 17:18:05', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(151, NULL, 12, 7, 20, '2025-05-19 17:18:06', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(152, NULL, 10, 1, 2, '2025-05-19 17:20:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(153, NULL, 12, 6, 16, '2025-05-19 17:22:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(154, NULL, 7, 10, 28, '2025-05-19 17:24:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(155, NULL, 4, 6, 18, '2025-05-19 17:24:28', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(156, NULL, 1, 7, 19, '2025-05-19 17:24:29', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(157, NULL, 1, 11, 31, '2025-05-19 17:24:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(158, NULL, 10, 3, 7, '2025-05-19 17:24:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(159, NULL, 7, 2, 6, '2025-05-19 17:24:31', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(160, NULL, 11, 1, 3, '2025-05-19 17:24:32', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(161, NULL, 11, 11, 31, '2025-05-19 17:24:33', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(162, NULL, 7, 7, 21, '2025-05-19 17:24:33', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(163, NULL, 5, 9, 26, '2025-05-19 17:24:34', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(164, NULL, 3, 5, 15, '2025-05-19 17:24:34', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(165, NULL, 2, 12, 35, '2025-05-19 17:26:38', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(166, NULL, 10, 11, 31, '2025-05-19 17:26:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(167, NULL, 11, 11, 31, '2025-05-19 17:26:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(168, NULL, 3, 5, 15, '2025-05-19 17:26:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(169, NULL, 4, 9, 27, '2025-05-19 17:28:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(170, NULL, 6, 6, 16, '2025-05-19 17:28:23', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(171, NULL, 3, 12, 36, '2025-05-19 17:28:23', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(172, NULL, 8, 1, 2, '2025-05-19 17:28:24', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(173, NULL, 3, 6, 18, '2025-05-19 17:28:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(174, NULL, 9, 11, 32, '2025-05-19 17:28:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(175, NULL, 5, 11, 32, '2025-05-19 17:28:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(176, NULL, 5, 5, 14, '2025-05-19 17:28:30', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(177, NULL, 8, 1, 2, '2025-05-19 17:28:31', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(178, NULL, 8, 1, 3, '2025-05-19 17:28:32', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(179, NULL, 9, 1, 3, '2025-05-19 17:28:32', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(180, NULL, 12, 5, 13, '2025-05-19 17:28:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(181, NULL, 12, 10, 29, '2025-05-19 17:28:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(182, NULL, 7, 6, 17, '2025-05-19 17:28:48', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(183, NULL, 1, 5, 13, '2025-05-19 17:28:50', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(184, NULL, 4, 4, 12, '2025-05-19 17:28:54', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(185, NULL, 5, 2, 4, '2025-05-19 17:28:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(186, NULL, 6, 9, 26, '2025-05-19 17:32:24', '{\"faccao\":\"H\", \"funcao\":\"Healer\", \"tipo_combate\":\"aleatorio\"}'),
(187, NULL, 2, 9, 25, '2025-05-19 17:32:25', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(188, NULL, 6, 6, 17, '2025-05-19 17:32:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(189, NULL, 6, 3, 8, '2025-05-19 17:32:35', '{\"faccao\":\"H\", \"funcao\":\"DPS\", \"tipo_combate\":\"Ranged\"}'),
(190, NULL, 4, 4, 12, '2025-05-19 17:32:46', '{\"faccao\":\"H\", \"funcao\":\"DPS\", \"tipo_combate\":\"Melee\"}'),
(191, NULL, 1, 2, 5, '2025-05-19 17:33:29', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(192, NULL, 6, 9, 26, '2025-05-19 17:33:38', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(193, NULL, 7, 8, 24, '2025-05-19 17:33:39', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(194, NULL, 4, 4, 11, '2025-05-19 17:33:39', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(195, NULL, 7, 11, 32, '2025-05-19 17:33:40', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(196, NULL, 6, 8, 23, '2025-05-19 17:33:41', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(197, NULL, 4, 9, 27, '2025-05-19 17:33:42', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(198, NULL, 4, 8, 22, '2025-05-19 17:33:43', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(199, NULL, 1, 12, 36, '2025-05-19 17:36:42', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(200, NULL, 4, 7, 19, '2025-05-19 17:36:49', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(201, NULL, 1, 8, 23, '2025-05-19 17:37:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(202, NULL, 10, 4, 11, '2025-05-19 17:37:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(203, NULL, 4, 10, 28, '2025-05-19 17:37:03', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(204, NULL, 9, 5, 13, '2025-05-19 17:37:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(205, NULL, 4, 7, 19, '2025-05-19 17:37:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(206, NULL, 3, 8, 24, '2025-05-19 17:39:41', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(207, NULL, 12, 11, 31, '2025-05-19 17:39:42', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(208, NULL, 5, 8, 23, '2025-05-19 17:39:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(209, NULL, 8, 7, 21, '2025-05-19 17:39:45', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(210, NULL, 4, 3, 9, '2025-05-19 17:39:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(211, NULL, 3, 9, 27, '2025-05-19 17:40:18', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(212, NULL, 8, 8, 24, '2025-05-19 17:40:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(213, NULL, 10, 6, 16, '2025-05-19 17:40:23', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(214, NULL, 9, 8, 23, '2025-05-19 17:40:25', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(215, NULL, 1, 4, 12, '2025-05-19 17:40:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(216, NULL, 11, 10, 29, '2025-05-19 17:43:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(217, NULL, 10, 3, 7, '2025-05-19 17:43:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(218, NULL, 6, 6, 16, '2025-05-19 17:44:39', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(219, NULL, 12, 11, 32, '2025-05-19 18:07:36', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(220, NULL, 2, 9, 26, '2025-05-19 18:07:40', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(221, NULL, 9, 10, 30, '2025-05-19 18:07:43', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(222, NULL, 9, 10, 29, '2025-05-19 18:07:43', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(223, NULL, 1, 5, 14, '2025-05-19 18:07:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(224, NULL, 12, 1, 1, '2025-05-19 18:07:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(225, NULL, 2, 1, 3, '2025-05-19 18:07:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(226, NULL, 8, 9, 25, '2025-05-19 18:07:45', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(227, NULL, 1, 7, 21, '2025-05-19 18:07:45', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(228, NULL, 2, 6, 16, '2025-05-19 18:07:45', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(229, NULL, 1, 12, 34, '2025-05-19 18:07:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(230, NULL, 8, 9, 26, '2025-05-19 18:07:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(231, NULL, 2, 3, 9, '2025-05-19 18:07:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(232, NULL, 11, 12, 34, '2025-05-19 18:07:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(233, NULL, 3, 9, 27, '2025-05-19 18:07:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(234, NULL, 2, 12, 36, '2025-05-19 18:07:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(235, NULL, 12, 1, 2, '2025-05-19 18:21:07', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(236, NULL, 8, 10, 30, '2025-05-19 18:21:27', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(237, NULL, 7, 7, 21, '2025-05-19 18:21:31', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(238, NULL, 6, 6, 18, '2025-05-19 18:21:34', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(239, NULL, 11, 6, 17, '2025-05-19 18:21:38', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(240, NULL, 6, 1, 3, '2025-05-19 18:22:57', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(241, NULL, 10, 8, 24, '2025-05-19 18:22:57', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(242, NULL, 6, 6, 18, '2025-05-19 18:23:15', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(243, NULL, 2, 1, 2, '2025-05-19 18:23:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(244, NULL, 4, 10, 28, '2025-05-19 18:23:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(245, NULL, 8, 2, 5, '2025-05-19 18:23:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(246, NULL, 6, 6, 16, '2025-05-19 19:00:56', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(247, NULL, 12, 5, 15, '2025-05-19 19:01:01', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(248, NULL, 11, 12, 33, '2025-05-19 19:01:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(249, NULL, 1, 4, 11, '2025-05-19 19:01:10', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(250, NULL, 2, 3, 7, '2025-05-19 19:01:13', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(251, NULL, 3, 12, 34, '2025-05-19 19:01:14', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(252, NULL, 6, 11, 31, '2025-05-19 19:01:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(253, NULL, 4, 3, 9, '2025-05-19 19:01:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(254, NULL, 2, 12, 36, '2025-05-19 19:01:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(255, NULL, 2, 7, 21, '2025-05-19 19:01:19', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(256, NULL, 9, 9, 27, '2025-05-19 19:01:21', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(257, NULL, 11, 6, 18, '2025-05-19 19:01:22', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(258, NULL, 5, 4, 12, '2025-05-19 19:01:24', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(259, NULL, 9, 10, 28, '2025-05-19 19:04:22', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(260, NULL, 4, 1, 1, '2025-05-19 19:04:26', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(261, NULL, 7, 12, 35, '2025-05-19 19:05:09', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(262, NULL, 6, 3, 7, '2025-05-19 19:05:09', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(263, NULL, 7, 7, 19, '2025-05-19 19:05:10', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(264, NULL, 9, 12, 36, '2025-05-19 19:05:12', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(265, NULL, 11, 11, 32, '2025-05-19 19:05:17', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(266, NULL, 11, 7, 19, '2025-05-19 19:10:44', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(267, NULL, 10, 11, 31, '2025-05-19 19:10:46', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(268, NULL, 5, 12, 33, '2025-05-19 19:10:48', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(269, NULL, 10, 1, 1, '2025-05-19 19:10:50', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(270, NULL, 4, 5, 14, '2025-05-19 19:10:51', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(271, NULL, 12, 11, 31, '2025-05-19 19:10:53', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(272, NULL, 2, 11, 31, '2025-05-19 19:10:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(273, NULL, 4, 8, 23, '2025-05-19 19:10:56', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(274, NULL, 12, 5, 13, '2025-05-19 19:10:57', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(275, NULL, 3, 9, 27, '2025-05-19 19:10:57', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(276, NULL, 12, 1, 2, '2025-05-19 19:10:59', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(277, NULL, 2, 6, 18, '2025-05-19 19:11:07', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(278, NULL, 2, 1, 1, '2025-05-19 19:11:38', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(279, NULL, 6, 8, 24, '2025-05-19 19:11:42', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(280, NULL, 9, 7, 20, '2025-05-19 19:11:47', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(281, NULL, 6, 8, 22, '2025-05-19 19:11:50', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(282, NULL, 6, 3, 9, '2025-05-19 19:11:52', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(283, NULL, 8, 9, 27, '2025-05-19 19:11:53', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(284, NULL, 8, 4, 12, '2025-05-19 19:11:54', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(285, NULL, 12, 12, 36, '2025-05-19 19:11:55', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(286, NULL, 3, 8, 22, '2025-05-19 19:11:58', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(287, NULL, 3, 7, 19, '2025-05-19 19:11:59', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(288, NULL, 7, 7, 19, '2025-05-19 19:12:00', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(289, NULL, 4, 9, 26, '2025-05-19 19:12:02', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(290, NULL, 4, 4, 12, '2025-05-19 19:15:59', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(291, NULL, 11, 10, 30, '2025-05-19 19:19:07', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(292, NULL, 10, 3, 7, '2025-05-19 19:19:07', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}'),
(293, NULL, 11, 1, 1, '2025-05-19 19:19:16', '{\"faccao\":\"aleatorio\", \"funcao\":\"aleatorio\", \"tipo_combate\":\"aleatorio\"}');

-- --------------------------------------------------------

--
-- Estrutura para tabela `racas`
--

CREATE TABLE `racas` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `faccao_id` char(1) NOT NULL,
  `descricao` text DEFAULT NULL,
  `ativa` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `racas`
--

INSERT INTO `racas` (`id`, `nome`, `faccao_id`, `descricao`, `ativa`) VALUES
(1, 'Orc', 'H', 'Guerreiros brutais com sede de batalha', 1),
(2, 'Tauren', 'H', 'Poderosos seres bovinos de grande força física', 1),
(3, 'Troll', 'H', 'Povo espiritual com grande agilidade', 1),
(4, 'Renegado', 'H', 'Rejeitados que escaparam do controle do Lich Rei', 1),
(5, 'Elfo Sangrento', 'H', 'Ex-elfos nobres corrompidos por magia arcana', 1),
(6, 'Goblin', 'H', 'Engenheiros mercenários ágeis e astutos', 1),
(7, 'Humano', 'A', 'Versáteis e adaptáveis, com espírito resiliente', 1),
(8, 'Anão', 'A', 'Robustos e resistentes, mestres em combate corpo a corpo', 1),
(9, 'Elfo Noturno', 'A', 'Seres místicos conectados à natureza', 1),
(10, 'Gnomo', 'A', 'Pequenos e inteligentes, especialistas em tecnologia', 1),
(11, 'Draenei', 'A', 'Nobres exilados com conexão divina', 1),
(12, 'Worgen', 'A', 'Humanos amaldiçoados com forma lupina', 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `raca_classe`
--

CREATE TABLE `raca_classe` (
  `raca_id` int(11) NOT NULL,
  `classe_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `raca_classe`
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
-- Estrutura para tabela `usuarios`
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

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vw_combinacoes_validas`
-- (Veja abaixo para a visão atual)
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
,`especializacao` varchar(50)
,`funcao` enum('DPS','Tank','Healer')
);

-- --------------------------------------------------------

--
-- Estrutura para view `vw_combinacoes_validas`
--
DROP TABLE IF EXISTS `vw_combinacoes_validas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_combinacoes_validas`  AS SELECT `r`.`id` AS `raca_id`, `r`.`nome` AS `raca`, `r`.`faccao_id` AS `faccao_id`, `f`.`nome` AS `faccao`, `c`.`id` AS `classe_id`, `c`.`nome` AS `classe`, `c`.`tipo_combate` AS `tipo_combate`, `e`.`id` AS `especializacao_id`, `e`.`nome` AS `especializacao`, `e`.`funcao` AS `funcao` FROM ((((`racas` `r` join `faccoes` `f` on(`r`.`faccao_id` = `f`.`id`)) join `raca_classe` `rc` on(`r`.`id` = `rc`.`raca_id`)) join `classes` `c` on(`rc`.`classe_id` = `c`.`id`)) join `especializacoes` `e` on(`c`.`id` = `e`.`classe_id`)) WHERE `r`.`ativa` = 1 ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `raca_id` (`raca_id`),
  ADD KEY `classe_id` (`classe_id`),
  ADD KEY `especializacao_id` (`especializacao_id`);

--
-- Índices de tabela `especializacoes`
--
ALTER TABLE `especializacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `classe_id` (`classe_id`);

--
-- Índices de tabela `faccoes`
--
ALTER TABLE `faccoes`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`),
  ADD KEY `raca_id` (`raca_id`),
  ADD KEY `classe_id` (`classe_id`),
  ADD KEY `especializacao_id` (`especializacao_id`);

--
-- Índices de tabela `racas`
--
ALTER TABLE `racas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faccao_id` (`faccao_id`);

--
-- Índices de tabela `raca_classe`
--
ALTER TABLE `raca_classe`
  ADD PRIMARY KEY (`raca_id`,`classe_id`),
  ADD KEY `classe_id` (`classe_id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nome_usuario` (`nome_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `especializacoes`
--
ALTER TABLE `especializacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de tabela `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=294;

--
-- AUTO_INCREMENT de tabela `racas`
--
ALTER TABLE `racas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `combinacoes_favoritas`
--
ALTER TABLE `combinacoes_favoritas`
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_2` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_3` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  ADD CONSTRAINT `combinacoes_favoritas_ibfk_4` FOREIGN KEY (`especializacao_id`) REFERENCES `especializacoes` (`id`);

--
-- Restrições para tabelas `especializacoes`
--
ALTER TABLE `especializacoes`
  ADD CONSTRAINT `especializacoes_ibfk_1` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`);

--
-- Restrições para tabelas `historico_randomizacoes`
--
ALTER TABLE `historico_randomizacoes`
  ADD CONSTRAINT `historico_randomizacoes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_2` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_3` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`),
  ADD CONSTRAINT `historico_randomizacoes_ibfk_4` FOREIGN KEY (`especializacao_id`) REFERENCES `especializacoes` (`id`);

--
-- Restrições para tabelas `racas`
--
ALTER TABLE `racas`
  ADD CONSTRAINT `racas_ibfk_1` FOREIGN KEY (`faccao_id`) REFERENCES `faccoes` (`id`);

--
-- Restrições para tabelas `raca_classe`
--
ALTER TABLE `raca_classe`
  ADD CONSTRAINT `raca_classe_ibfk_1` FOREIGN KEY (`raca_id`) REFERENCES `racas` (`id`),
  ADD CONSTRAINT `raca_classe_ibfk_2` FOREIGN KEY (`classe_id`) REFERENCES `classes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
