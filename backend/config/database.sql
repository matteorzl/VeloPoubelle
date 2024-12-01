-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 01 déc. 2024 à 16:13
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `velopoubelle`
--

-- --------------------------------------------------------

--
-- Structure de la table `arret`
--

CREATE TABLE `arret` (
  `id_arret` int(11) NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `rue_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `arret`
--

INSERT INTO `arret` (`id_arret`, `nom`, `lat`, `lng`, `rue_id`) VALUES
(1, 'Louis Blanc', 48.8761, 2.3638, 7),
(2, 'Jaurès', 48.8836, 2.3752, 7),
(3, 'Bolivar', 48.8842, 2.3772, 7),
(4, 'Buttes Chaumont', 48.8767, 2.3805, 7),
(5, 'Botzaris', 48.878, 2.3875, 7),
(6, 'Place des Fêtes', 48.8765, 2.3986, 7),
(7, 'Pré Saint-Gervais', 48.8846, 2.4005, 7),
(8, 'Porte Dauphine', 48.8746, 2.2787, 2),
(9, 'Victor Hugo', 48.8732, 2.2887, 2),
(10, 'Charles de Gaulle-Étoile', 48.8738, 2.295, 2),
(11, 'Ternes', 48.8796, 2.2945, 2),
(12, 'Courcelles', 48.8839, 2.3016, 2),
(13, 'Monceau', 48.8791, 2.3132, 2),
(14, 'Villiers', 48.8842, 2.3256, 2),
(15, 'Rome', 48.884, 2.3326, 2),
(16, 'Place de Clichy', 48.8847, 2.3254, 2),
(17, 'Blanche', 48.8846, 2.3333, 2),
(18, 'Pigalle', 48.8833, 2.3378, 2),
(19, 'Anvers', 48.884, 2.343, 2),
(20, 'Barbès-Rochechouart', 48.8848, 2.3481, 2),
(21, 'La Chapelle', 48.8863, 2.3573, 2),
(22, 'Stalingrad', 48.8832, 2.365, 2),
(23, 'Jaurès', 48.8836, 2.3752, 2),
(24, 'Colonel Fabien', 48.8779, 2.3813, 2),
(25, 'Belleville', 48.8673, 2.3773, 2),
(26, 'Couronnes', 48.8646, 2.3807, 2),
(27, 'Ménilmontant', 48.8619, 2.3834, 2),
(28, 'Père Lachaise', 48.8606, 2.3916, 2),
(29, 'Philippe Auguste', 48.8605, 2.3997, 2),
(30, 'Alexandre Dumas', 48.8594, 2.4085, 2),
(31, 'Avron', 48.8495, 2.4147, 2),
(32, 'Nation', 48.8483, 2.3952, 2),
(33, 'Pont du Garigliano', 48.8325, 2.2725, 15),
(34, 'Balard', 48.8292, 2.2758, 15),
(35, 'Desnouettes', 48.8286, 2.279, 15),
(36, 'Porte de Versailles', 48.832, 2.289, 15),
(37, 'Georges Brassens', 48.8263, 2.292, 15),
(38, 'Brancion', 48.8239, 2.2961, 15),
(39, 'Porte de Vanves', 48.8191, 2.3034, 15),
(40, 'Didot', 48.8201, 2.3103, 15),
(41, 'Jean Moulin', 48.8234, 2.3167, 15),
(42, "Porte d'Orléans", 48.8259, 2.3207, 15),
(43, 'Montsouris', 48.8255, 2.3265, 15),
(44, 'Cité universitaire', 48.8259, 2.3353, 15),
(45, 'Stade Charléty', 48.8294, 2.3411, 15),
(46, 'Poterne des Peupliers', 48.8366, 2.3417, 15),
(47, "Porte d'Italie", 48.8324, 2.3507, 15),
(48, 'Porte de Choisy', 48.8237, 2.359, 15),
(49, "Porte d'Ivry", 48.8179, 2.3703, 15),
(50, 'Bibliothèque François Mitterrand', 48.8329, 2.3744, 15),
(51, 'Porte de Charenton', 48.8373, 2.3846, 15),
(52, 'Porte Dorée', 48.8402, 2.3972, 15),
(53, 'Montempoivre', 48.8473, 2.4034, 15),
(54, 'Porte de Vincennes', 48.8474, 2.4063, 15),
(55, 'La Défense', 48.8925, 2.2381, 1),
(56, 'Esplanade de la Défense', 48.8882, 2.2503, 1),
(57, 'Pont de Neuilly', 48.8841, 2.2567, 1),
(58, 'Les Sablons', 48.8815, 2.2694, 1),
(59, 'Porte Maillot', 48.8786, 2.2821, 1),
(60, 'Argentine', 48.8756, 2.2903, 1),
(61, 'Charles de Gaulle-Étoile', 48.8738, 2.295, 1),
(62, 'George V', 48.8722, 2.3003, 1),
(63, 'Franklin D. Roosevelt', 48.8699, 2.3072, 1),
(64, 'Champs-Élysées-Clemenceau', 48.8663, 2.3131, 1),
(65, 'Concorde', 48.8655, 2.3211, 1),
(66, 'Tuileries', 48.8636, 2.328, 1),
(67, 'Palais Royal-Musée du Louvre', 48.8625, 2.336, 1),
(68, 'Louvre-Rivoli', 48.8618, 2.3419, 1),
(69, 'Châtelet', 48.8584, 2.347, 1),
(70, 'Hôtel de Ville', 48.8574, 2.3513, 1),
(71, 'Saint-Paul', 48.8555, 2.3625, 1),
(72, 'Bastille', 48.8532, 2.3693, 1),
(73, 'Gare de Lyon', 48.8443, 2.3748, 1),
(74, 'Reuilly-Diderot', 48.8497, 2.386, 1),
(75, 'Nation', 48.8483, 2.3952, 1),
(76, 'Porte de Vincennes', 48.8474, 2.4063, 1),
(77, 'Saint-Mandé', 48.8446, 2.4151, 1),
(78, 'Bérault', 48.842, 2.4236, 1),
(79, 'Château de Vincennes', 48.844, 2.4358, 1),
(80, 'La Défense', 48.8925, 2.2381, 14),
(81, 'Puteaux', 48.8807, 2.2446, 14),
(82, 'Belvédère', 48.8801, 2.2442, 14),
(83, 'Suresnes-Longchamp', 48.8766, 2.2261, 14),
(84, 'Les Coteaux', 48.8773, 2.2151, 14),
(85, 'Les Milons', 48.8761, 2.2085, 14),
(86, 'Parc de Saint-Cloud', 48.8485, 2.2119, 14),
(87, 'Musée de Sèvres', 48.8041, 2.2046, 14),
(88, 'Brimborion', 48.7913, 2.2194, 14),
(89, 'Meudon-sur-Seine', 48.7843, 2.2263, 14),
(90, 'Les Moulineaux', 48.7882, 2.2523, 14),
(91, 'Jacques-Henri Lartigue', 48.7826, 2.2628, 14),
(92, 'Issy-Val de Seine', 48.8284, 2.2752, 14),
(93, 'Balard', 48.8292, 2.2758, 14),
(94, 'Porte de Versailles', 48.832, 2.289, 14),
(95, 'Saint-Lazare', 48.8738, 2.325, 12),
(96, 'Madeleine', 48.8691, 2.3218, 12),
(97, 'Pyramides', 48.8658, 2.3325, 12),
(98, 'Châtelet', 48.8584, 2.347, 12),
(99, 'Gare de Lyon', 48.8443, 2.3748, 12),
(100, 'Bercy', 48.8345, 2.378, 12),
(101, 'Cour Saint-Émilion', 48.8331, 2.3809, 12),
(102, 'Bibliothèque François Mitterrand', 48.8329, 2.3744, 12),
(103, 'Porte de Clichy', 48.8949, 2.3216, 18),
(104, 'Pereire', 48.8856, 2.3145, 18),
(105, 'Porte Maillot', 48.8786, 2.2821, 18),
(106, 'Avenue Foch', 48.8756, 2.2849, 18),
(107, 'Avenue Henri Martin', 48.867, 2.2871, 18),
(108, 'La Muette', 48.8613, 2.2782, 18),
(109, 'Avenue du Président Kennedy', 48.8601, 2.2886, 18),
(110, 'Champ de Mars-Tour Eiffel', 48.8553, 2.2981, 18),
(111, "Pont de l'Alma", 48.8637, 2.3085, 18),
(112, 'Invalides', 48.8554, 2.3113, 18),
(113, "Musée d'Orsay", 48.86, 2.325, 18),
(114, 'Saint-Michel-Notre-Dame', 48.8531, 2.347, 18),
(115, "Gare d'Austerlitz", 48.841, 2.367, 18),
(116, 'Bibliothèque François Mitterrand', 48.8329, 2.3744, 18),
(117, 'Porte de la Chapelle', 48.896, 2.3577, 10),
(118, 'Marx Dormoy', 48.8906, 2.3622, 10),
(119, 'Marcadet-Poissonniers', 48.8891, 2.3458, 10),
(120, 'Jules Joffrin', 48.8887, 2.3385, 10),
(121, 'Lamarck-Caulaincourt', 48.8885, 2.3402, 10),
(122, 'Abbesses', 48.8847, 2.3375, 10),
(123, 'Pigalle', 48.8833, 2.3378, 10),
(124, 'Saint-Georges', 48.8821, 2.3281, 10),
(125, 'Notre-Dame-de-Lorette', 48.8811, 2.3253, 10),
(126, "Trinité-d'Estienne d'Orves", 48.8754, 2.3328, 10),
(127, 'Saint-Lazare', 48.8738, 2.325, 10),
(128, 'Madeleine', 48.8691, 2.3218, 10),
(129, 'Concorde', 48.8655, 2.3211, 10),
(130, 'Assemblée nationale', 48.8611, 2.32, 10),
(131, 'Solférino', 48.86, 2.314, 10),
(132, 'Rue du Bac', 48.8565, 2.3184, 10),
(133, 'Sèvres-Babylone', 48.854, 2.3201, 10),
(134, 'Rennes', 48.841, 2.3279, 10),
(135, 'Notre-Dame-des-Champs', 48.841, 2.3301, 10),
(136, 'Montparnasse-Bienvenüe', 48.8438, 2.3211, 10),
(137, 'Falguière', 48.841, 2.3189, 10),
(138, 'Pasteur', 48.8401, 2.3132, 10),
(139, 'Volontaires', 48.8382, 2.3012, 10),
(140, 'Vaugirard', 48.8365, 2.2949, 10),
(141, 'Convention', 48.8325, 2.2906, 10),
(142, 'Porte de Versailles', 48.832, 2.289, 10),
(143, 'Corentin Celton', 48.8221, 2.2906, 10),
(144, "Mairie d'Issy", 48.821, 2.2786, 10),
(145, 'Bobigny-Pablo Picasso', 48.9075, 2.4331, 4),
(146, 'Bobigny-Pantin-Raymond', 48.9042, 2.4212, 4),
(147, 'Queneau', 48.8995, 2.413, 4),
(148, 'Église de Pantin', 48.8997, 2.4056, 4),
(149, 'Hoche', 48.8955, 2.3985, 4),
(150, 'Porte de Pantin', 48.892, 2.3898, 4),
(151, 'Ourcq', 48.8891, 2.3821, 4),
(152, 'Laumière', 48.8844, 2.3759, 4),
(153, 'Jaurès', 48.8836, 2.3752, 4),
(154, 'Stalingrad', 48.8832, 2.365, 4),
(155, 'Gare du Nord', 48.88, 2.3556, 4),
(156, "Gare de l'Est", 48.8762, 2.3575, 4),
(157, 'Jacques Bonsergent', 48.8711, 2.3597, 4),
(158, 'République', 48.867, 2.3622, 4),
(159, 'Oberkampf', 48.8644, 2.3715, 4),
(160, 'Richard-Lenoir', 48.8633, 2.3748, 4),
(161, 'Bréguet-Sabin', 48.8619, 2.3752, 4),
(162, 'Bastille', 48.8532, 2.3693, 4),
(163, 'Quai de la Rapée', 48.8456, 2.3702, 4),
(164, "Gare d'Austerlitz", 48.841, 2.367, 4),
(165, 'Saint-Marcel', 48.8413, 2.3659, 4),
(166, 'Campo-Formio', 48.839, 2.3582, 4),
(167, "Porte d'Italie", 48.8324, 2.3507, 4),
(168, 'La Courneuve-8 Mai 1945', 48.9097, 2.3735, 6),
(169, "Fort d'Aubervilliers", 48.9083, 2.3964, 6),
(170, 'Aubervilliers-Pantin-Quatre Chemins', 48.902, 2.3961, 6),
(171, 'Porte de la Villette', 48.8931, 2.3791, 6),
(172, 'Corentin Cariou', 48.8937, 2.3784, 6),
(173, 'Crimée', 48.8911, 2.3747, 6),
(174, 'Riquet', 48.8897, 2.3705, 6),
(175, 'Stalingrad', 48.8832, 2.365, 6),
(176, 'Louis Blanc', 48.8761, 2.3638, 6),
(177, 'Château-Landon', 48.8784, 2.3623, 6),
(178, "Gare de l'Est", 48.8762, 2.3575, 6),
(179, 'Poissonnière', 48.8752, 2.3468, 6),
(180, 'Cadet', 48.8763, 2.3452, 6),
(181, 'Le Peletier', 48.8739, 2.3441, 6),
(182, "Chaussée d'Antin-La Fayette", 48.8736, 2.3389, 6),
(183, 'Opéra', 48.8723, 2.3319, 6),
(184, 'Pyramides', 48.8658, 2.3325, 6),
(185, 'Palais Royal-Musée du Louvre', 48.8625, 2.336, 6),
(186, 'Pont Neuf', 48.8584, 2.3427, 6),
(187, 'Châtelet', 48.8584, 2.347, 6),
(188, 'Pont Marie', 48.8569, 2.3584, 6),
(189, 'Sully-Morland', 48.8544, 2.3619, 6),
(190, 'Jussieu', 48.8444, 2.3576, 6),
(191, 'Place Monge', 48.8423, 2.3585, 6),
(192, 'Censier-Daubenton', 48.8413, 2.3587, 6),
(193, 'Les Gobelins', 48.8416, 2.3603, 6),
(194, "Place d'Italie", 48.8328, 2.3512, 6),
(195, 'Tolbiac', 48.8295, 2.357, 6),
(196, 'Maison Blanche', 48.8283, 2.3591, 6),
(197, "Porte d'Italie", 48.8324, 2.3507, 6),
(198, 'Porte de Choisy', 48.8237, 2.359, 6),
(199, "Porte d'Ivry", 48.8179, 2.3703, 6),
(200, 'Pierre et Marie Curie', 48.8356, 2.3525, 6),
(201, "Mairie d'Ivry", 48.8182, 2.3964, 6),
(202, 'Gare Saint-Denis', 48.9384, 2.3587, 13),
(203, 'Théâtre Gérard Philipe', 48.9337, 2.3569, 13),
(204, 'Marché de Saint-Denis', 48.9301, 2.3589, 13),
(205, 'Basilique de Saint-Denis', 48.9364, 2.357, 13),
(206, 'Cimetière de Saint-Denis', 48.9294, 2.3527, 13),
(207, 'Hôpital Delafontaine', 48.9272, 2.3447, 13),
(208, 'Cosmonautes', 48.9331, 2.4139, 13),
(209, 'La Courneuve-Six Routes', 48.9271, 2.4313, 13),
(210, 'Hôtel de Ville de La Courneuve', 48.9352, 2.4327, 13),
(211, 'Stade Géo André', 48.9287, 2.4278, 13),
(212, 'Danton', 48.9138, 2.4345, 13),
(213, 'La Courneuve-8 Mai 1945', 48.9097, 2.3735, 13),
(214, 'Maurice Lachâtre', 48.9119, 2.3618, 13),
(215, 'Drancy-Avenir', 48.9202, 2.4794, 13),
(216, 'Hôpital Avicenne', 48.9251, 2.4684, 13),
(217, 'Gaston Roulaud', 48.9276, 2.4448, 13),
(218, 'Escadrille Normandie-Niémen', 48.9305, 2.4189, 13),
(219, 'La Ferme', 48.9267, 2.4294, 13),
(220, 'Libération', 48.9238, 2.4264, 13),
(221, 'Hôtel de Ville de Bobigny', 48.9052, 2.4334, 13),
(222, 'Bobigny-Pablo Picasso', 48.9075, 2.4331, 13),
(223, 'Jean Rostand', 48.9032, 2.4729, 13),
(224, 'Auguste Delaune', 48.9045, 2.4637, 13),
(225, 'Pont de Bondy', 48.9106, 2.4532, 13),
(226, 'Petit Noisy', 48.8978, 2.4597, 13),
(227, 'Noisy-le-Sec', 48.8933, 2.5083, 13),
(228, 'Boulogne-Pont de Saint-Cloud', 48.8409, 2.2471, 21),
(229, 'Boulogne-Jean Jaurès', 48.8412, 2.2546, 21),
(230, "Porte d'Auteuil", 48.84, 2.2557, 21),
(231, 'Michel-Ange-Auteuil', 48.8436, 2.2535, 21),
(232, "Église d'Auteuil", 48.8472, 2.2525, 21),
(233, 'Javel-André Citroën', 48.8413, 2.2807, 21),
(234, 'Charles Michels', 48.8416, 2.288, 21),
(235, 'Avenue Émile Zola', 48.8501, 2.2895, 21),
(236, 'La Motte-Picquet-Grenelle', 48.8491, 2.295, 21),
(237, 'Ségur', 48.8449, 2.3141, 21),
(238, 'Duroc', 48.8431, 2.3212, 21),
(239, 'Vaneau', 48.8444, 2.3237, 21),
(240, 'Sèvres-Babylone', 48.854, 2.3201, 21),
(241, 'Mabillon', 48.8534, 2.335, 21),
(242, 'Odéon', 48.8535, 2.3385, 21),
(243, 'Cluny-La Sorbonne', 48.8484, 2.3449, 21),
(244, 'Maubert-Mutualité', 48.8481, 2.353, 21),
(245, 'Cardinal Lemoine', 48.847, 2.3587, 21),
(246, 'Jussieu', 48.8444, 2.3576, 21),
(247, "Gare d'Austerlitz", 48.841, 2.367, 21),
(248, 'Saint-Denis-Université', 48.917, 2.3585, 11),
(249, 'Basilique de Saint-Denis', 48.9364, 2.357, 11),
(250, 'Saint-Denis-Porte de Paris', 48.9372, 2.3604, 11),
(251, 'Carrefour Pleyel', 48.9095, 2.3215, 11),
(252, 'Mairie de Saint-Ouen', 48.8998, 2.3326, 11),
(253, 'Garibaldi', 48.8957, 2.3383, 11),
(254, 'Porte de Saint-Ouen', 48.8941, 2.3337, 11),
(255, 'Guy Môquet', 48.8962, 2.3263, 11),
(256, 'La Fourche', 48.891, 2.3216, 11),
(257, 'Place de Clichy', 48.8847, 2.3254, 11),
(258, 'Liège', 48.8807, 2.3317, 11),
(259, 'Saint-Lazare', 48.8738, 2.325, 11),
(260, 'Miromesnil', 48.8721, 2.3175, 11),
(261, 'Champs-Élysées-Clemenceau', 48.8663, 2.3131, 11),
(262, 'Invalides', 48.8554, 2.3113, 11),
(263, 'Varenne', 48.8544, 2.319, 11),
(264, 'Saint-François-Xavier', 48.85, 2.3199, 11),
(265, 'Duroc', 48.8431, 2.3212, 11),
(266, 'Montparnasse-Bienvenüe', 48.8438, 2.3211, 11),
(267, 'Gaîté', 48.8433, 2.3254, 11),
(268, 'Pernety', 48.8417, 2.3285, 11),
(269, 'Plaisance', 48.8412, 2.3334, 11),
(270, 'Porte de Vanves', 48.8191, 2.3034, 11),
(271, 'Malakoff-Plateau de Vanves', 48.8223, 2.3101, 11),
(272, 'Malakoff-Rue Etienne Dolet', 48.8195, 2.3054, 11),
(273, 'Châtillon-Montrouge', 48.8147, 2.3123, 11),
(274, 'Châtelet', 48.8584, 2.347, 22),
(275, 'Hôtel de Ville', 48.8574, 2.3513, 22),
(276, 'Rambuteau', 48.8606, 2.3569, 22),
(277, 'Arts et Métiers', 48.8663, 2.3562, 22),
(278, 'République', 48.867, 2.3622, 22),
(279, 'Goncourt', 48.8702, 2.3766, 22),
(280, 'Belleville', 48.8673, 2.3773, 22),
(281, 'Pyrénées', 48.8781, 2.3904, 22),
(282, 'Jourdain', 48.8797, 2.3984, 22),
(283, 'Place des Fêtes', 48.8765, 2.3986, 22),
(284, 'Télégraphe', 48.8883, 2.4081, 22),
(285, 'Porte des Lilas', 48.8899, 2.4133, 22),
(286, 'Mairie des Lilas', 48.8886, 2.4201, 22),
(287, 'La Défense', 48.8925, 2.2381, 16),
(288, 'Charles de Gaulle-Étoile', 48.8738, 2.295, 16),
(289, 'Auber', 48.873, 2.3327, 16),
(290, 'Châtelet-Les Halles', 48.86, 2.3483, 16),
(291, 'Gare de Lyon', 48.8443, 2.3748, 16),
(292, 'Nation', 48.8483, 2.3952, 16),
(293, 'Pont de Levallois-Bécon', 48.8947, 2.2894, 24),
(294, 'Anatole France', 48.893, 2.287, 24),
(295, 'Louise Michel', 48.8923, 2.2818, 24),
(296, 'Porte de Champerret', 48.886, 2.2931, 24),
(297, 'Pereire', 48.8856, 2.3145, 24),
(298, 'Wagram', 48.8845, 2.3115, 24),
(299, 'Malesherbes', 48.8795, 2.3169, 24),
(300, 'Villiers', 48.8842, 2.3256, 24),
(301, 'Europe', 48.8747, 2.3249, 24),
(302, 'Saint-Lazare', 48.8738, 2.325, 24),
(303, 'Havre-Caumartin', 48.8733, 2.334, 24),
(304, 'Opéra', 48.8723, 2.3319, 24),
(305, 'Quatre-Septembre', 48.8701, 2.34, 24),
(306, 'Bourse', 48.8706, 2.3443, 24),
(307, 'Sentier', 48.8676, 2.3504, 24),
(308, 'Réaumur-Sébastopol', 48.8649, 2.3528, 24),
(309, 'Arts et Métiers', 48.8663, 2.3562, 24),
(310, 'Temple', 48.8641, 2.363, 24),
(311, 'République', 48.867, 2.3622, 24),
(312, 'Parmentier', 48.8666, 2.3766, 24),
(313, 'Rue Saint-Maur', 48.8696, 2.3803, 24),
(314, 'Père Lachaise', 48.8606, 2.3916, 24),
(315, 'Gambetta', 48.8643, 2.3985, 24),
(316, 'Porte de Bagnolet', 48.8607, 2.4095, 24),
(317, 'Gallieni', 48.8547, 2.4137, 24),
(318, 'Balard', 48.8292, 2.2758, 8),
(319, 'Lourmel', 48.8311, 2.2732, 8),
(320, 'Boucicaut', 48.8285, 2.2735, 8),
(321, 'Félix Faure', 48.8259, 2.2767, 8),
(322, 'Commerce', 48.8403, 2.2902, 8),
(323, 'La Motte-Picquet-Grenelle', 48.8491, 2.295, 8),
(324, 'École Militaire', 48.8551, 2.311, 8),
(325, 'La Tour-Maubourg', 48.8606, 2.3139, 8),
(326, 'Invalides', 48.8554, 2.3113, 8),
(327, 'Concorde', 48.8655, 2.3211, 8),
(328, 'Madeleine', 48.8691, 2.3218, 8),
(329, 'Opéra', 48.8723, 2.3319, 8),
(330, 'Richelieu-Drouot', 48.8741, 2.3449, 8),
(331, 'Grands Boulevards', 48.8734, 2.3497, 8),
(332, 'Bonne Nouvelle', 48.8696, 2.3529, 8),
(333, 'Strasbourg-Saint-Denis', 48.8681, 2.357, 8),
(334, 'République', 48.867, 2.3622, 8),
(335, 'Filles du Calvaire', 48.8662, 2.3722, 8),
(336, 'Saint-Sébastien-Froissart', 48.8646, 2.3743, 8),
(337, 'Chemin Vert', 48.8614, 2.3761, 8),
(338, 'Bastille', 48.8532, 2.3693, 8),
(339, 'Ledru-Rollin', 48.8464, 2.3737, 8),
(340, 'Faidherbe-Chaligny', 48.8427, 2.3806, 8),
(341, 'Reuilly-Diderot', 48.8497, 2.386, 8),
(342, 'Montgallet', 48.8332, 2.3935, 8),
(343, 'Daumesnil', 48.8321, 2.3955, 8),
(344, 'Michel Bizot', 48.8311, 2.4017, 8),
(345, 'Porte Dorée', 48.8402, 2.3972, 8),
(346, 'Porte de Charenton', 48.8373, 2.3846, 8),
(347, 'Liberté', 48.8265, 2.4182, 8),
(348, 'Charenton-Écoles', 48.8183, 2.4276, 8),
(349, 'École Vétérinaire de Maisons-Alfort', 48.796, 2.4392, 8),
(350, 'Maisons-Alfort-Stade', 48.7951, 2.4384, 8),
(351, 'Maisons-Alfort-Les Juilliottes', 48.7918, 2.4289, 8),
(352, "Créteil-L'Echat", 48.7832, 2.4276, 8),
(353, 'Créteil-Université', 48.7795, 2.431, 8),
(354, 'Créteil-Préfecture', 48.7777, 2.4409, 8),
(355, 'Charles de Gaulle-Étoile', 48.8738, 2.295, 5),
(356, 'Kléber', 48.8693, 2.2901, 5),
(357, 'Boissière', 48.8666, 2.2892, 5),
(358, 'Trocadéro', 48.8607, 2.2916, 5),
(359, 'Passy', 48.8607, 2.2832, 5),
(360, 'Champ de Mars-Tour Eiffel', 48.8553, 2.2981, 5),
(361, 'Dupleix', 48.8529, 2.2877, 5),
(362, 'La Motte-Picquet-Grenelle', 48.8491, 2.295, 5),
(363, 'Cambronne', 48.8473, 2.2962, 5),
(364, 'Sèvres-Lecourbe', 48.8434, 2.3026, 5),
(365, 'Pasteur', 48.8401, 2.3132, 5),
(366, 'Montparnasse-Bienvenüe', 48.8438, 2.3211, 5),
(367, 'Edgar Quinet', 48.8437, 2.3259, 5),
(368, 'Raspail', 48.8401, 2.325, 5),
(369, 'Denfert-Rochereau', 48.8437, 2.3252, 5),
(370, 'Saint-Jacques', 48.8372, 2.3464, 5),
(371, 'Glacière', 48.8326, 2.3513, 5),
(372, 'Corvisart', 48.8315, 2.3531, 5),
(373, "Place d'Italie", 48.8328, 2.3512, 5),
(374, 'Nationale', 48.8324, 2.3709, 5),
(375, 'Chevaleret', 48.832, 2.374, 5),
(376, 'Quai de la Gare', 48.8323, 2.3813, 5),
(377, 'Bercy', 48.8345, 2.378, 5),
(378, 'Dugommier', 48.8317, 2.3841, 5),
(379, 'Daumesnil', 48.8321, 2.3955, 5),
(380, 'Bel-Air', 48.832, 2.4046, 5),
(381, 'Picpus', 48.8327, 2.4173, 5),
(382, 'Nation', 48.8483, 2.3952, 5),
(383, 'Porte de Clignancourt', 48.8896, 2.3378, 23),
(384, 'Simplon', 48.8887, 2.343, 23),
(385, 'Marcadet-Poissonniers', 48.8891, 2.3458, 23),
(386, 'Château Rouge', 48.8842, 2.3427, 23),
(387, 'Barbès-Rochechouart', 48.8848, 2.3481, 23),
(388, 'Gare du Nord', 48.88, 2.3556, 23),
(389, "Gare de l'Est", 48.8762, 2.3575, 23),
(390, "Château d'Eau", 48.8739, 2.3585, 23),
(391, 'Strasbourg-Saint-Denis', 48.8681, 2.357, 23),
(392, 'Réaumur-Sébastopol', 48.8649, 2.3528, 23),
(393, 'Étienne Marcel', 48.8626, 2.3519, 23),
(394, 'Les Halles', 48.86, 2.3469, 23),
(395, 'Châtelet', 48.8584, 2.347, 23),
(396, 'Cité', 48.8554, 2.3505, 23),
(397, 'Saint-Michel-Notre-Dame', 48.8531, 2.347, 23),
(398, 'Odéon', 48.8535, 2.3385, 23),
(399, 'Saint-Germain-des-Prés', 48.855, 2.3335, 23),
(400, 'Saint-Sulpice', 48.8533, 2.3335, 23),
(401, 'Saint-Placide', 48.8509, 2.3313, 23),
(402, 'Montparnasse-Bienvenüe', 48.8438, 2.3211, 23),
(403, 'Vavin', 48.8423, 2.3255, 23),
(404, 'Raspail', 48.8401, 2.325, 23),
(405, 'Denfert-Rochereau', 48.8437, 2.3252, 23),
(406, 'Mouton-Duvernet', 48.8359, 2.324, 23),
(407, 'Alésia', 48.832, 2.3265, 23),
(408, "Porte d'Orléans", 48.8259, 2.3207, 23),
(409, 'Gambetta', 48.8643, 2.3985, 3),
(410, 'Pelleport', 48.8695, 2.4031, 3),
(411, 'Saint-Fargeau', 48.8755, 2.4017, 3),
(412, 'Porte des Lilas', 48.8899, 2.4133, 3),
(413, 'Pont de Sèvres', 48.832, 2.229, 9),
(414, 'Billancourt', 48.8334, 2.2385, 9),
(415, 'Marcel Sembat', 48.8307, 2.2454, 9),
(416, 'Porte de Saint-Cloud', 48.8345, 2.2527, 9),
(417, 'Exelmans', 48.8378, 2.2676, 9),
(418, 'Michel-Ange-Molitor', 48.8403, 2.2697, 9),
(419, 'Michel-Ange-Auteuil', 48.8436, 2.2535, 9),
(420, 'Jasmin', 48.845, 2.2873, 9),
(421, 'Ranelagh', 48.8494, 2.2895, 9),
(422, 'La Muette', 48.8613, 2.2782, 9),
(423, 'Rue de la Pompe', 48.8565, 2.28, 9),
(424, 'Trocadéro', 48.8607, 2.2916, 9),
(425, 'Iéna', 48.8643, 2.2896, 9),
(426, 'Alma-Marceau', 48.8658, 2.3023, 9),
(427, 'Franklin D. Roosevelt', 48.8699, 2.3072, 9),
(428, 'Saint-Philippe du Roule', 48.868, 2.306, 9),
(429, 'Miromesnil', 48.8721, 2.3175, 9),
(430, 'Saint-Augustin', 48.8753, 2.318, 9),
(431, 'Havre-Caumartin', 48.8733, 2.334, 9),
(432, "Chaussée d'Antin-La Fayette", 48.8736, 2.3389, 9),
(433, 'Richelieu-Drouot', 48.8741, 2.3449, 9),
(434, 'Grands Boulevards', 48.8734, 2.3497, 9),
(435, 'Bonne Nouvelle', 48.8696, 2.3529, 9),
(436, 'Strasbourg-Saint-Denis', 48.8681, 2.357, 9),
(437, 'République', 48.867, 2.3622, 9),
(438, 'Oberkampf', 48.8644, 2.3715, 9),
(439, 'Saint-Ambroise', 48.8643, 2.3807, 9),
(440, 'Voltaire', 48.8614, 2.384, 9),
(441, 'Charonne', 48.8604, 2.3935, 9),
(442, 'Rue des Boulets', 48.8571, 2.3965, 9),
(443, 'Nation', 48.8483, 2.3952, 9),
(444, 'Buzenval', 48.8497, 2.4103, 9),
(445, 'Maraîchers', 48.8448, 2.4129, 9),
(446, 'Porte de Montreuil', 48.8434, 2.4199, 9),
(447, 'Robespierre', 48.8414, 2.423, 9),
(448, 'Croix de Chavaux', 48.8416, 2.4266, 9),
(449, 'Mairie de Montreuil', 48.8497, 2.4361, 9),
(450, 'Gare du Nord', 48.88, 2.3556, 19),
(451, 'Châtelet-Les Halles', 48.86, 2.3483, 19),
(452, 'Gare de Lyon', 48.8443, 2.3748, 19),
(453, 'Saint-Lazare', 48.8738, 2.325, 20),
(454, 'Gare du Nord', 48.88, 2.3556, 20),
(455, 'Gare du Nord', 48.88, 2.3556, 17),
(456, 'Châtelet-Les Halles', 48.86, 2.3483, 17),
(457, 'Saint-Michel-Notre-Dame', 48.8531, 2.347, 17),
(458, 'Luxembourg', 48.8462, 2.3378, 17),
(459, 'Port-Royal', 48.8425, 2.3341, 17),
(460, 'Denfert-Rochereau', 48.8437, 2.3252, 17),
(461, 'Cité universitaire', 48.8259, 2.3353, 17);

-- --------------------------------------------------------

--
-- Structure de la table `incident`
--

CREATE TABLE `incident` (
  `id_incident` int(11) NOT NULL,
  `trajet_id` int(11) DEFAULT NULL,
  `type` enum('accident','arret_supprime','panne','rue_bloquee') DEFAULT NULL,
  `description` text DEFAULT NULL,
  `heure` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `rue`
--

CREATE TABLE `rue` (
  `id_rue` int(11) NOT NULL,
  `nom` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `rue`
--

INSERT INTO `rue` (`id_rue`, `nom`) VALUES
(1, 'Croix-Baragnon'),
(2, 'Arts'),
(3, 'Saint-Rome'),
(4, 'Fonderie'),
(5, 'Peyrolières'),
(6, 'Genty-Magre'),
(7, 'Alsace-Lorraine'),
(8, 'Peyras'),
(9, 'Taur'),
(10, 'Filatiers'),
(11, 'Mage'),
(12, 'Espinasse'),
(13, 'Gestes'),
(14, 'Daurade'),
(15, 'Bédelières'),
(16, 'Merlane'),
(17, 'Vélane'),
(18, 'Etroite'),
(19, 'Tourneurs'),
(20, 'Trinité'),
(21, 'Jean Jaurès'),
(22, 'May'),
(23, 'Saint-Antoine du T'),
(24, 'Pargaminières');

-- --------------------------------------------------------

--
-- Structure de la table `tournee`
--

CREATE TABLE `tournee` (
  `id_tournee` int(11) NOT NULL,
  `nom` varchar(255) NOT NULL,
  `date` date DEFAULT NULL,
  `cycliste_id` int(11) DEFAULT NULL,
  `etat` enum('planifiee','en_cours','terminee') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `trajet`
--

CREATE TABLE `trajet` (
  `id_trajet` int(11) NOT NULL,
  `tournee_id` int(11) DEFAULT NULL,
  `id_arret` int(11) NOT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `ordre_passage` int(11) DEFAULT NULL,
  `isDone` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id_utilisateur` int(11) NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `prenom` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mot_de_passe` varchar(255) DEFAULT NULL,
  `role` enum('cycliste','gestionnaire_reseau','RH','administrateur') DEFAULT NULL,
  `isSick` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Structure de la table `velo`
--

CREATE TABLE `velo` (
  `id_velo` int(11) NOT NULL,
  `autonomie` int(11) DEFAULT NULL,
  `capacite` int(11) DEFAULT NULL,
  `etat` enum('disponible','utilisé','en_maintenance') DEFAULT 'disponible',
  `cycliste_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `velo`
--

INSERT INTO `velo` (`id_velo`, `autonomie`, `capacite`, `etat`, `cycliste_id`) VALUES
(1, 50000, 200, 'disponible', NULL),
(2, 50000, 200, 'disponible', NULL),
(3, 50000, 200, 'disponible', NULL),
(4, 50000, 200, 'disponible', NULL),
(5, 50000, 200, 'disponible', NULL),
(6, 50000, 200, 'disponible', NULL),
(7, 50000, 200, 'disponible', NULL),
(8, 50000, 200, 'disponible', NULL),
(9, 50000, 200, 'disponible', NULL),
(10, 50000, 200, 'disponible', NULL),
(11, 50000, 200, 'disponible', NULL),
(12, 50000, 200, 'disponible', NULL),
(13, 50000, 200, 'disponible', NULL),
(14, 50000, 200, 'disponible', NULL),
(15, 50000, 200, 'disponible', NULL),
(16, 50000, 200, 'disponible', NULL);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `arret`
--
ALTER TABLE `arret`
  ADD PRIMARY KEY (`id_arret`),
  ADD KEY `rue_id` (`rue_id`);

--
-- Index pour la table `incident`
--
ALTER TABLE `incident`
  ADD PRIMARY KEY (`id_incident`),
  ADD KEY `trajet_id` (`trajet_id`);

--
-- Index pour la table `rue`
--
ALTER TABLE `rue`
  ADD PRIMARY KEY (`id_rue`);

--
-- Index pour la table `tournee`
--
ALTER TABLE `tournee`
  ADD PRIMARY KEY (`id_tournee`),
  ADD KEY `velo_id` (`cycliste_id`);

--
-- Index pour la table `trajet`
--
ALTER TABLE `trajet`
  ADD PRIMARY KEY (`id_trajet`),
  ADD KEY `tournee_id` (`tournee_id`),
  ADD KEY `trajet_arret` (`id_arret`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id_utilisateur`);

--
-- Index pour la table `velo`
--
ALTER TABLE `velo`
  ADD PRIMARY KEY (`id_velo`),
  ADD KEY `cycliste_id` (`cycliste_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `arret`
--
ALTER TABLE `arret`
  MODIFY `id_arret` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=462;

--
-- AUTO_INCREMENT pour la table `tournee`
--
ALTER TABLE `tournee`
  MODIFY `id_tournee` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT pour la table `trajet`
--
ALTER TABLE `trajet`
  MODIFY `id_trajet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=522;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id_utilisateur` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT pour la table `velo`
--
ALTER TABLE `velo`
  MODIFY `id_velo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `arret`
--
ALTER TABLE `arret`
  ADD CONSTRAINT `arret_ibfk_1` FOREIGN KEY (`rue_id`) REFERENCES `rue` (`id_rue`);

--
-- Contraintes pour la table `incident`
--
ALTER TABLE `incident`
  ADD CONSTRAINT `incident_ibfk_1` FOREIGN KEY (`trajet_id`) REFERENCES `trajet` (`id_trajet`);

--
-- Contraintes pour la table `tournee`
--
ALTER TABLE `tournee`
  ADD CONSTRAINT `tournee_ibfk_1` FOREIGN KEY (`cycliste_id`) REFERENCES `utilisateur` (`id_utilisateur`);

--
-- Contraintes pour la table `trajet`
--
ALTER TABLE `trajet`
  ADD CONSTRAINT `trajet_arret` FOREIGN KEY (`id_arret`) REFERENCES `arret` (`id_arret`),
  ADD CONSTRAINT `trajet_ibfk_2` FOREIGN KEY (`tournee_id`) REFERENCES `tournee` (`id_tournee`);

--
-- Contraintes pour la table `velo`
--
ALTER TABLE `velo`
  ADD CONSTRAINT `velo_ibfk_1` FOREIGN KEY (`cycliste_id`) REFERENCES `utilisateur` (`id_utilisateur`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
