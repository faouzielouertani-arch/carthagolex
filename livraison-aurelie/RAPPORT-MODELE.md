# RAPPORT DE CONFORMITÉ EU AI ACT

---

**Client** : [Nom du client]
**Système IA analysé** : [Nom du système]
**Rôle du client** : [Fournisseur / Déployeur / Les deux]
**Date du rapport** : [AAAA-MM-JJ]
**Référence** : [Référence interne]
**Préparé par** : [Votre nom / cabinet]
**Outil d'analyse** : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
**Auteur** : EL OUERTANI FAOUZI

---

## 1. Identification du système

| Champ | Valeur |
|-------|--------|
| Nom du système | [À remplir] |
| Version | [À remplir] |
| Fournisseur / développeur | [À remplir] |
| Déployeur / utilisateur final | [À remplir] |
| Domaine d'application | [emploi / éducation / biométrie / santé / …] |
| Description courte | [À remplir] |
| Date de mise en service (prévue) | [À remplir] |

---

## 2. Classification de risque — Résultat de l'analyse

| Champ | Valeur |
|-------|--------|
| **Niveau de risque** | 🟢 Minimal / 🟡 Limité / 🟠 Élevé / 🔴 Inacceptable |
| **Confiance de l'analyse** | Élevée / Moyenne / Faible |
| **Catégorie Annexe III** | [n° — nom] (si applicable) |
| **Base de classification** | [signals / description / default] |
| **Rôle déterminé** | Fournisseur / Déployeur / Incertain |

### Articles applicables
| Article | Sujet |
|---------|-------|
| [ex. Art. 6(2)] | Classification haut risque (Annexe III) |
| [ex. Art. 26] | Obligations du déployeur |
| [ex. Art. 27] | FRIA |
| [ex. Art. 5(1)(h)] | Prohibition (le cas échéant) |

### Avertissements et exceptions
- [ex. L'exception Art. 6(3) peut s'appliquer si… → à évaluer via `euaiact_assess_art6_3_exception`]
- [ex. Pratique potentiellement prohibée sous Art. 5(1)(h) → à confirmer juridiquement]

---

## 3. Obligations applicables

### 3.1 En tant que [Fournisseur]

| Obligation | Article | Échéance | Statut |
|------------|---------|----------|--------|
| [Ex: Système de gestion des risques] | Art. 9 | 2027-12-02 | ⬜ À faire |
| [Ex: Documentation technique (Annex IV)] | Art. 11 | 2027-12-02 | ⬜ À faire |
| [Ex: Enregistrement base de données UE] | Art. 49 | 2027-12-02 | ⬜ À faire |
| [Ex: Évaluation de conformité] | Art. 43 | 2027-12-02 | ⬜ À faire |
| [Ex: Surveillance post-marché] | Art. 72 | 2027-12-02 | ⬜ À faire |
| [Ex: Transparence] | Art. 50 | 2026-08-02 | ⬜ À faire |

### 3.2 En tant que [Déployeur]

| Obligation | Article | Échéance | Statut |
|------------|---------|----------|--------|
| [Ex: Usage conformément aux instructions] | Art. 26(1) | 2027-12-02 | ⬜ À faire |
| [Ex: Supervision humaine par personnes compétentes] | Art. 26(2) | 2027-12-02 | ⬜ À faire |
| [Ex: Pertinence des données d'entrée] | Art. 26(4) | 2027-12-02 | ⬜ À faire |
| [Ex: Surveillance et signalement] | Art. 26(5)-(6) | 2027-12-02 | ⬜ À faire |
| [Ex: AIPD (DPIA)] | Art. 26(9) | 2027-12-02 | ⬜ À faire |
| [Ex: FRIA si Art. 27 applicable] | Art. 27 | 2027-12-02 | ⬜ À faire |

---

## 4. Échéances de conformité

| Date | Jalon | Statut | Jours restants |
|------|-------|--------|---------------|
| 2025-02-02 | Pratiques prohibées (Art. 5) + littératie IA (Art. 4) | ✅ En vigueur | — |
| 2026-08-02 | Transparence (Art. 50) + GPAI | ✅ En vigueur | — |
| 2026-12-02 | Nouvelles prohibitions Art. 5(1)(ba)/(bb) | ⬜ À venir | [~78 j] |
| 2027-12-02 | Obligations complètes haut risque Annexe III | ⬜ À venir | [~443 j] |
| 2028-08-02 | Obligations haut risque Annexe I (produits réglementés) | ⬜ À venir | [~697 j] |

---

## 5. Sanctions encourues

### 5.1 Sanction maximale — Non-conformité haut risque (Art. 99(4))

| Paramètre | Valeur |
|-----------|--------|
| Type de violation | Obligations haut risque |
| CA mondial annuel | [X €] |
| PME ? | Oui / Non |
| **Amende maximale** | **[15 000 000 € ou 3 % du CA, le plus élevé]** |
| Plafond fixe | 15 000 000 € |
| Basé sur le CA | [3 % × CA] € |
| Amende applicable (si PME) | [1 500 000 €] |

### 5.2 Sanction maximale — Pratique prohibée (Art. 99(3))

| Paramètre | Valeur |
|-----------|--------|
| **Amende maximale** | **[35 000 000 € ou 7 % du CA, le plus élevé]** |
| Plafond fixe | 35 000 000 € |
| Basé sur le CA | [7 % × CA] € |

> ⚠️ Une pratique prohibée entraîne l'**interdiction** du système, en plus de l'amende.

---

## 6. Checklist technique — Annexe IV (systèmes haut risque)

> À compléter pour chaque système haut risque. Cochez chaque élément.

### 6.1 Description générale du système IA
- [ ] Description générale (objectif, version, fournisseur)
- [ ] Interaction avec le matériel/logiciel
- [ ] Formes de mise sur le marché
- [ ] Interface utilisateur pour le déployeur
- [ ] Instructions d'utilisation

### 6.2 Description détaillée des éléments et du développement
- [ ] Méthodes et étapes de développement
- [ ] Choix de conception (logique, algorithmes)
- [ ] Architecture du système
- [ ] Exigences de données (training/validation/testing)
- [ ] Mesures de supervision humaine (Art. 14)
- [ ] Procédures de validation et de test
- [ ] Métriques de précision, robustesse, conformité
- [ ] Mesures de cybersécurité

### 6.3 Surveillance, fonctionnement et contrôle
- [ ] Capacités et limites du système
- [ ] Performances attendues et niveaux de précision
- [ ] Robustesse et correction d'erreurs
- [ ] Spécifications de supervision humaine

### 6.4 Risques résiduels et mesures
- [ ] Risques identifiés non éliminables
- [ ] Mesures d'atténuation mises en place

### 6.5 Modifications du système
- [ ] Journal des modifications et versions
- [ ] Procédure de mise à jour

### 6.6 Normes harmonisées
- [ ] Normes appliquées (référence)
- [ ] Solutions alternatives le cas échéant

### 6.7 Système de post-marché
- [ ] Procédure de surveillance post-marché (Art. 72)
- [ ] Système de signalement d'incidents graves (Art. 73)
- [ ] Procédure de gestion des plaintes

### 6.8 Évaluation de conformité
- [ ] Méthode d'évaluation de conformité (Art. 43)
- [ ] Déclaration UE de conformité (Art. 47)
- [ ] Enregistrement base de données UE (Art. 49)

---

## 7. Synthèse et recommandations

### 7.1 Constat principal
Le système « [Nom] » est classé **[niveau de risque]** au sens du Règlement (UE) 2024/1689.

### 7.2 Actions prioritaires
1. [Action 1 — ex: lancer l'évaluation de l'exception Art. 6(3)]
2. [Action 2 — ex: établir la documentation Annexe IV]
3. [Action 3 — ex: mettre en place la supervision humaine]
4. [Action 4 — ex: enregistrement base de données UE]

### 7.3 Prochaines échéances critiques
- **[Date]** : [Jalon] → [action requise]
- **[Date]** : [Jalon] → [action requise]

### 7.4 Recommandation finale
[Ex: Le système doit être mis en conformité avant le 2 décembre 2027. Une évaluation
juridique complémentaire est recommandée pour confirmer l'applicabilité de l'exception
Art. 6(3) et de la FRIA (Art. 27).]

---

## 8. Références légales

| Référence | Lien |
|-----------|------|
| Règlement (UE) 2024/1689 (AI Act) | [EUR-Lex](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727) |
| Règlement (UE) 2026/1744 (Digital Omnibus) | [EUR-Lex](https://eur-lex.europa.eu/) |
| Article [X] | [lien EUR-Lex spécifique] |

---

## 9. Avertissement

Ce rapport est une **orientation de premier niveau** générée par un outil d'analyse
automatisé. Il ne constitue **pas un avis juridique**. Pour une classification définitive
et des décisions de conformité, consulter un juriste spécialisé en droit de l'IA
et/ou un DPO.

L'outil utilisé (`eu-ai-act-conformite` v1.5.0) applique la logique du
Règlement (UE) 2024/1689 modifié par (UE) 2026/1744. Les résultats sont déterministes
et reproductibles (490 tests comportementaux, 120/120 tests de déterminisme).

---

**Signature** : [Votre nom]
**Date** : [AAAA-MM-JJ]
**Contact** : [email / téléphone]

---

*Modèle de rapport généré pour Aurélie LAFFARGUE — EL OUERTANI FAOUZI*
*Validation humaine requise par un DPO ou spécialiste audit de conformité*
