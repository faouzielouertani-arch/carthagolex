# Cartographie des obligations — carte d'orientation

Cette carte sert uniquement de fil conducteur pour interroger les sources. Elle ne remplace jamais la récupération du texte : chaque article cité doit avoir été servi par un connecteur, avec URL. Toute divergence entre cette carte et le texte servi tranche en faveur du texte servi.

## 1. Articles pivots par rôle

| Rôle | Article | Objet (à confirmer par récupération) |
|---|---|---|
| Fabricant | art. 13 | Conception, analyse des risques, documentation technique, période de support |
| Fabricant | annexe I, partie II | Traitement des vulnérabilités : identification, remédiation, divulgation coordonnée, mises à jour |
| Fabricant | annexe I, partie I | Exigences essentielles de cybersécurité |
| Importateur | art. 19 | Vérifications avant mise sur le marché, transmission des manquements |
| Distributeur | art. 20 | Vérifications, conservation, transmission des manquements |
| Transfert d'obligations | art. 21 | Propre nom/marque ; modification substantielle → obligations de fabricant |
| Intendant logiciel libre | art. 24 | Régime distinct et allégé, limites de signalement propres |

## 2. Périmètre et classification

| Élément | Article / acte | Objet |
|---|---|---|
| Périmètre | art. 2 | Produits à éléments numériques, exclusions sectorielles |
| Définitions | art. 3 | Notions clés, dont « vulnérabilité activement exploitée » |
| Catégories | annexes | Produits importants I/II, critiques |
| Descriptions techniques | règl. d'exécution (UE) 2025/2392 | Détail des catégories |

## 3. Structure de l'article 14 (notification)

1. Alertes précoces pour vulnérabilités activement exploitées et incidents graves — délais à lire dans le texte servi.
2. Notification initiale puis rapport final, avec échelonnement propre.
3. Branche « incident grave » avec ses seuils.
4. Rapports intermédiaires sur demande.
5. Destinataires : CSIRT coordinateur et ENISA via la plateforme unique.
6. Devoir distinct d'informer les utilisateurs concernés — et le cas échéant tous.

## 4. Dates — articles 69 et 71

Toujours récupérer art. 71 (application) et art. 69 (transitoires). L'article 14 s'applique avant le corps principal. L'acte délégué sur la dissémination différée ne proroge jamais les délais du notifiant.

## 5. Régimes voisins — points de contrôle

| Régime | Points de contrôle |
|---|---|
| NIS2 (directive (UE) 2022/2555) | Transposition nationale ; type et taille d'entité ; secteurs en annexe |
| RGPD (règlement (UE) 2016/679) | Art. 33 (72 h, exception sans risque) ; art. 34 (risque élevé) ; rôle responsable/traitant |
| DORA (règlement (UE) 2022/2554) | Entités du périmètre ; lex specialis vs NIS2 à vérifier depuis les textes |

## 6. Test « vulnérabilité activement exploitée » — raisonnement attendu

1. Récupérer la définition servie (art. 3).
2. Examiner les preuves d'exploitation non autorisée réelle : seule base suffisante.
3. EPSS, CVSS et preuves de concept ne satisfont jamais seuls la définition ; inscription KEV = preuve à l'appui.
4. Confirmer séparément le confinement dans le produit et les versions de l'utilisateur.
5. Si les deux branches sont satisfaites : dérouler l'article 14 depuis la date de prise de connaissance (jamais la date d'ajout KEV).
