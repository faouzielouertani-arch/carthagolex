# LIVRABLE — Outil d'analyse de conformité EU AI Act

---

**Destinataire** : Aurélie LAFFARGUE
**Objet** : Ressources, méthodes de travail et architecture de déploiement
**Produit** : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
**Auteur** : EL OUERTANI FAOUZI
**Licence** : MIT
**Préparé par** : EL OUERTANI FAOUZI
**Date** : 2025-09-15
**Sources légales** : Règlement (UE) 2024/1689 modifié par Règlement (UE) 2026/1744

---

## 1. OBJET DU DOCUMENT

Le présent document décrit :

1. Les **ressources** mobilisées par l'outil d'analyse de conformité EU AI Act
2. Les **méthodes de travail** appliquées (déterminisme, ancrage juridique, traçabilité)
3. L'**architecture de déploiement** et le **choix de souveraineté** de l'hébergeur :
   - Option A — Déploiement **interne** (on-premise, souveraineté totale)
   - Option B — Déploiement via **Mistral Code / Le Chat** (souveraineté européenne)

Ce document est destiné à un usage **professionnel, technique et juridique**.

---

## 2. CHOIX DE SOUVERAINETÉ — ARCHITECTURE DE DÉPLOIEMENT

### Principe

Le serveur EU AI Act MCP est un **logiciel libre** (licence MIT). Il peut être
déployé dans deux architectures distinctes, selon le niveau de souveraineté
recherché par l'organisation.

### Option A — Déploiement interne (on-premise) — Souveraineté totale

| Caractéristique | Détail |
|----------------|--------|
| Hébergement | Serveur interne de l'organisation |
| Données | Aucune donnée ne sort du périmètre organisationnel |
| Souveraineté | Totale — l'organisation contrôle l'intégralité du système |
| Accès | Réseau interne uniquement (ou VPN) |
| Dépendance externe | Aucune (sauf clonage initial depuis GitHub) |

**Architecture** :
```
[Poste client] → [Serveur MCP interne] → [Moteur de classification]
                        ↓
               [Règlement (UE) 2024/1689 — intégré au serveur]
```

**Déploiement** :
```bash
# Sur le serveur interne
git clone https://github.com/faouzielouertani-arch/eu-ai-act-conformite.git
cd eu-ai-act-mcp
npm install
npm run build
PORT=3000 node dist/http.js
```

**Avantages** :
- Aucune donnée transmise à un tiers
- Conformité RGPD simplifiée (pas de sous-traitant externe)
- Contrôle total des mises à jour et de la disponibilité
- Adapté aux secteurs réglementés (défense, santé, finance)

**Inconvénients** :
- Maintenance à la charge de l'organisation
- Pas d'accès depuis l'extérieur sans configuration réseau

### Option B — Déploiement via Mistral Code / Le Chat — Souveraineté européenne

| Caractéristique | Détail |
|----------------|--------|
| Hébergement | Mistral AI (entreprise française, hébergement européen) |
| Données | Traitées par un acteur européen soumis au RGPD |
| Souveraineté | Européenne — données hébergées en UE, soumis au droit de l'UE |
| Accès | Via Le Chat (https://chat.mistral.ai) ou API Mistral |
| Dépendance externe | Mistral AI (acteur européen) |

**Architecture** :
```
[Le Chat / Mistral Code] → [Connecteur MCP distant] → [Serveur MCP déployé]
                                                              ↓
                                                  [Règlement (UE) 2024/1689 — intégré]
```

**Déploiement** :
1. Déployer le serveur sur une plateforme cloud (Railway, Scaleway, OVH — acteur européen recommandé)
2. Ajouter l'URL publique du serveur comme **connecteur MCP personnalisé** dans Le Chat de Mistral :
   - Intelligence → Connectors → Add custom connector
   - URL : `https://votre-serveur.up.railway.app/mcp`
3. Activer le connecteur dans la conversation

**Avantages** :
- Acteur européen (Mistral AI, soumis au RGPD et au droit de l'UE)
- Accès depuis n'importe où
- Pas de maintenance infrastructurelle si déployé sur PaaS
- Intégration native avec l'écosystème Mistral

**Inconvénients** :
- Données traitées par un tiers (Mistral AI — acteur européen sous RGPD)
- Nécessite une URL publique pour le connecteur MCP distant

### Comparatif de souveraineté

| Critère | Option A (interne) | Option B (Mistral) |
|---------|--------------------|--------------------|
| Souveraineté des données | **Totale** | Européenne (RGPD) |
| Hébergement | Serveur interne | UE (Mistral AI) |
| Sous-traitant RGPD | Aucun | Mistral AI (art. 28 RGPD) |
| Accès distant | Non (sauf VPN) | Oui |
| Maintenance | Organisation | Partagée |
| Adapté secteurs régulés | ✅ Oui | ⚠️ Sous conditions |

### Recommandation

> Le serveur étant **read-only** (aucune donnée n'est stockée, aucun apprentissage,
> aucune persistance), le risque de fuite de données est minimal dans les deux options.
>
> - Pour les organisations soumises à des contraintes de souveraineté fortes
>   (défense, santé, administration publique) → **Option A (interne)**
> - Pour les organisations cherchant un équilibre souveraineté/accessibilité
>   (cabinets juridiques, consulting, PME) → **Option B (Mistral)**

---

## 3. RESSOURCES MOBILISÉES

### 3.1 Sources juridiques intégrées au serveur

| Source | Référence | Statut |
|--------|-----------|--------|
| Règlement AI Act | Règlement (UE) 2024/1689 | En vigueur depuis le 1er février 2025 |
| Digital Omnibus sur l'IA | Règlement (UE) 2026/1744 | Publié au JO UE le 24/07/2026, en vigueur depuis le 27/07/2026 |
| Annexe III | Catégories de systèmes haut risque (8 catégories) | Opératoire |
| Annexe IV | Documentation technique requise | Opératoire |
| Annexe I | Produits réglementés (législation d'harmonisation UE) | Opératoire |
| Annexe XI | Documentation GPAI | Opératoire |
| Annexe XII | Info pour intégrateurs aval (GPAI) | Opératoire |
| EUR-Lex | Plateforme officielle de publication | Réutilisation sous Décision 2011/833/UE |

### 3.2 Outils exposés par le serveur (10 outils MCP)

| Outil | Fonction | Article de référence |
|------|----------|---------------------|
| `euaiact_classify_system` | Classification de risque (4 niveaux) + catégorie Annexe III | Art. 6, Annexe III |
| `euaiact_assess_system` | Évaluation bornée complète (classification + impact + maturité) | Art. 6-27 |
| `euaiact_assess_art6_3_exception` | Évaluation de l'exception Art. 6(3) (sortie du haut risque) | Art. 6(3)-(4) |
| `euaiact_check_gpai_systemic_risk` | Seuil de risque systémique GPAI (1e25 FLOPs) | Art. 51-53 |
| `euaiact_check_deadlines` | Échéances de conformité (Digital Omnibus inclus) | Art. 113 |
| `euaiact_get_article` | Récupération du texte d'un article + lien EUR-Lex | Variable |
| `euaiact_get_obligations` | Obligations par rôle (fournisseur / déployeur) et niveau de risque | Art. 16, 26, 50, 53 |
| `euaiact_calculate_penalty` | Calcul des amendes (Art. 99, 101) | Art. 99(3)-(6), 101 |
| `euaiact_annex_iv_checklist` | Checklist de documentation technique Annexe IV | Annexe IV |
| `euaiact_answer_question` | Réponse libre ancrée dans le règlement | Variable |

### 3.3 Ressources MCP exposées

Le serveur expose également des **ressources** consultables via le protocole MCP :

| Ressource | Contenu |
|-----------|---------|
| `euaiact://annex-iii` | Catégories de systèmes IA haut risque (Annexe III) |
| `euaiact://annex-iv` | Exigences de documentation technique (Annexe IV) |
| `euaiact://timeline` | Calendrier d'application (incluant Digital Omnibus) |
| `euaiact://omnibus` | Détails du Digital Omnibus sur l'IA (CELEX 32026R1744) |
| `euaiact://risk-levels` | Définition des 4 niveaux de risque |

---

## 4. MÉTHODES DE TRAVAIL

### 4.1 Validation humaine requise

Les sorties produites par le serveur sont **automatiques et déterministes**.
Elles ne doivent **pas** être utilisées telles quelles pour une décision de
conformité finale. Une **validation humaine est requise** avant toute exploitation.

| Étape | Validateur | Objet de la validation |
|------|-----------|----------------------|
| Classification | DPO ou spécialiste audit de conformité | Confirmer le niveau de risque et la catégorie Annexe III |
| Exceptions (Art. 6(3)) | DPO ou juriste IA | Vérifier les conditions d'application de l'exception |
| Obligations | DPO ou spécialiste audit | Confirmer les obligations par rôle et leur applicabilité |
| Échéances | Responsable conformité | Vérifier les dates butoirs applicables au système |
| Amendes | Direction juridique | Confirmer le type de violation et le régime d'amende |
| Checklist Annexe IV | DPO ou auditeur | Valider la complétude de la documentation technique |

> ⚠️ **Sans validation humaine d'un DPO ou d'un spécialiste en audit de conformité**, les
> résultats de l'outil ne peuvent pas être opposés à un tiers, à une autorité de
> surveillance ou à un client. L'outil produit une **orientation** ; la décision de
> conformité reste **humaine et documentée**.

### 4.2 Déterminisme et reproductibilité

| Propriété | Garantie |
|-----------|----------|
| Déterminisme | Mêmes entrées = mêmes sorties (vérifié 120/120 hashes canoniques) |
| Reproductibilité | Aucun aléatoire, aucun appel à un modèle d'IA génératif |
| Auditabilité | Chaque sortie est reproductible et défendable |
| Tests | 490 tests comportementaux + 124 assertions de claims + 48 tests de schémas |

### 4.3 Ancrage juridique

Chaque sortie du serveur :

1. **Cite l'article exact** du Règlement (UE) 2024/1689 applicable
2. **Fournit le lien EUR-Lex** officiel vers le texte source
3. **Indique la base de classification** (signaux structurés / description / défaut)
4. **Signale les exceptions** applicables (ex. Art. 6(3)) et leurs conditions
5. **Distingue le droit opératoire** du contenu non publié au Journal Officiel

### 4.4 Limites méthodologiques

| Limite | Traitement |
|--------|------------|
| Orientation de premier niveau | Affiché dans chaque réponse (« first-pass guidance ») |
| Pas un avis juridique | Mention explicite dans chaque sortie |
| Classification définitive | Nécessite un juriste / DPO |
| Contenu non-OJ | Signalé comme non opposable jusqu'à publication au JO |

### 4.5 Process de travail recommandé

```
Étape 1 : Description du système
   → Le client décrit son système IA (texte libre ou signaux structurés)

Étape 2 : Classification automatisée
   → euaiact_classify_system → niveau de risque + catégorie Annexe III + articles

Étape 3 : Évaluation des exceptions (si applicable)
   → euaiact_assess_art6_3_exception (système Annexe III potentiellement sortant)

Étape 4 : Obligations détaillées
   → euaiact_get_obligations → obligations par rôle + dates d'application

Étape 5 : Échéances
   → euaiact_check_deadlines → calendrier de conformité

Étape 6 : Évaluation des sanctions
   → euaiact_calculate_penalty → amende maximale encourue

Étape 7 : Checklist technique (si haut risque)
   → euaiact_annex_iv_checklist → liste des éléments de documentation à produire

Étape 8 : Rapport
   → Compilation des sorties en rapport de conformité (modèle fourni)

Étape 9 : Validation juridique
   → Un juriste / DPO valide la classification et les obligations
```

---

## 5. VALIDATION TECHNIQUE

### 5.1 Vérification officielle (`npm run verify`)

| Gate | Statut | Résultat |
|------|--------|---------|
| Clean build | ✅ PASS | dist généré |
| Behavior suite | ✅ PASS | 490/490 |
| Claim matrix | ✅ PASS | 124/124 |
| Schema gate | ✅ PASS | 48/48 |
| Corpus verification | ✅ PASS | 4 documents vérifiés |
| Compiler tests | ✅ PASS | Tests passés |
| Public-eval grader | ✅ PASS | 20 cas ; baseline match |
| Golden determinism | ✅ PASS | 12 profils × 10 runs = 120 hashes |
| Package content | ✅ PASS | 183 fichiers ; dist présent |
| Version identity | ✅ PASS | v1.5.0 cohérent |

### 5.2 Cas réels validés (4 scénarios)

| Cas | Système | Classification | Articles clés |
|-----|---------|---------------|---------------|
| 1 | Recrutement IA (tri de CV) | Haut risque | Annexe III(4), Art. 6(2), 26, 27 |
| 2 | Reconnaissance faciale publique | Haut risque + alerte prohibition | Annexe III(1), Art. 5(1)(h) |
| 3 | Chatbot e-commerce | Limité | Art. 50(1) |
| 4 | GPAI 3e25 FLOPs | Risque systémique | Art. 51(2), 53 |

---

## 6. CAS PRATIQUE — TEST COMPLET NIVEAU RH

### 6.1 Scénario

Une PME française (25 M€ de CA, statut PME) utilise une solution IA pour **trier
et classer automatiquement les candidats** à l'embauche. Le système **profile les
candidats** et **influence les décisions de recrutement**. L'entreprise est
déployeur (elle n'a pas développé le système).

### 6.2 Étape 1 — Classification (`euaiact_classify_system`)

**Requête** : domain=employment, profiling=true, decisions affectant des individus=true

**Résultat** :

| Champ | Valeur |
|-------|--------|
| Classification | 🟠 **Haut risque** |
| Confiance | **Élevée** |
| Catégorie Annexe III | **(4) Emploi, gestion des travailleurs et accès au travail indépendant** |
| Articles applicables | Annexe III(4), Art. 6(2), Art. 26(7), Art. 27 |
| Rôle déterminé | **Déployeur** |

### 6.3 Étape 2 — Exception Art. 6(3) (`euaiact_assess_art6_3_exception`)

**Requête** : performs_profiling=true, annex_iii_number=4

**Résultat** :

| Champ | Valeur |
|-------|--------|
| Exception disponible | ❌ **Non** |
| Raison | Le système **profile des personnes** → l'exception Art. 6(3) est **incompatible** avec le profilage (Art. 6(3), 3e alinéa), indépendamment des autres conditions |
| Conditions (a)-(d) | Toutes évaluées à `false` |
| Conclusion | Le système **reste haut risque** sous Art. 6(2) et doit se conformer au Chapitre III Section 2 |

### 6.4 Étape 3 — Obligations du déployeur (`euaiact_get_obligations`)

**Résultat** — 6 obligations, toutes applicables au **2 décembre 2027** :

| Obligation | Article | Catégorie |
|------------|---------|-----------|
| Usage conforme aux instructions | Art. 26(1) | Opérationnel |
| Supervision humaine par personnes compétentes | Art. 26(2) | Supervision humaine |
| Pertinence des données d'entrée | Art. 26(4) | Gouvernance des données |
| Surveillance et signalement | Art. 26(5)-(6) | Surveillance |
| AIPD (DPIA) | Art. 26(9) | Protection des données |
| FRIA (Art. 27) | Art. 27 | Droits fondamentaux |

**Détails clés** :
- Art. 26(5)-(6) : conserver les logs **au moins 6 mois** sous le contrôle du déployeur
- Art. 26(7) : informer les **représentants du personnel et les travailleurs** avant usage en milieu de travail
- Art. 27 : la FRIA est obligatoire car le système relève de l'Annexe III(4)

### 6.5 Étape 4 — Échéances (`euaiact_check_deadlines`)

| Date | Jalon | Statut | Jours restants |
|------|-------|--------|---------------|
| 2027-12-02 | Obligations complètes haut risque Annexe III | ⬜ À venir | 443 jours |
| 2028-08-02 | Obligations Annexe I (produits réglementés) | ⬜ À venir | 687 jours |

### 6.6 Étape 5 — Amendes (`euaiact_calculate_penalty`)

**Requête** : violation_type=high_risk, CA=25 M€, PME=true

| Paramètre | Valeur |
|-----------|--------|
| Type de violation | Obligations haut risque (Art. 99(4)) |
| CA mondial | 25 000 000 € |
| Statut | **PME** (Art. 99(6)) |
| **Amende maximale** | **750 000 €** (3 % × 25 M€ = 750 000 € ; plafond PME applicable) |
| Si non-PME | 15 000 000 € (plafond fixe) |
| Réduction PME | 14 250 000 € |

### 6.7 Étape 6 — Checklist Annexe IV (`euaiact_annex_iv_checklist`)

Le serveur renvoie la checklist technique complète. Extrait des sections principales :

1. **Description générale du système** : objectif, version, interaction matériel/logiciel, instructions d'usage
2. **Description détaillée** : méthodes de développement, architecture, données (training/validation/testing), supervision humaine (Art. 14), cybersécurité
3. **Surveillance et contrôle** : capacités, limites, précision attendue, résultats imprévus
4. **Risques résiduels** : risques identifiés non éliminables + mesures d'atténuation
5. **Modifications** : journal des versions, procédure de mise à jour
6. **Normes harmonisées** : normes appliquées + solutions alternatives
7. **Surveillance post-marché** : Art. 72 (surveillance), Art. 73 (incidents graves)
8. **Évaluation de conformité** : Art. 43 (méthode), Art. 47 (déclaration UE), Art. 49 (enregistrement base UE)

### 6.8 Étape 7 — Article 26 complet (`euaiact_get_article`)

Le serveur renvoie le texte de l'Art. 26 avec le lien EUR-Lex officiel :

> **Art. 26 — Obligations des déployeurs de systèmes IA haut risque**
>
> Les déployeurs doivent : prendre des mesures techniques et organisationnelles pour
> un usage conforme aux instructions ; assigner la supervision humaine à des personnes
> compétentes, formées et autorisées ; assurer la pertinence des données d'entrée ;
> surveiller le fonctionnement et notifier le fournisseur/autorité en cas de risque ;
> signaler les incidents graves ; conserver les logs **au moins 6 mois** ; informer
> les représentants du personnel avant usage en milieu de travail ; informer les
> personnes soumises à un usage Annexe III (Art. 26(11)) ; réaliser une AIPD si
> requis ; coopérer avec les autorités compétentes.

**Lien EUR-Lex** : https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727#art_26

### 6.9 Synthèse du cas RH

```
Système : Tri de CV automatisé avec profilage
Rôle : Déployeur (PME, CA 25 M€)

Classification : 🟠 HAUT RISQUE (Annexe III(4))
Exception Art. 6(3) : ❌ NON (profilage disqualifiant)

Obligations : 6 obligations déployeur → échéance 2 décembre 2027
  - Usage conforme, supervision humaine, données, surveillance, AIPD, FRIA

Amende maximale : 750 000 € (régime PME Art. 99(6))
Échéance critique : 2 décembre 2027 (443 jours restants)

⚠️ Validation requise : DPO ou spécialiste audit de conformité
```

### 6.10 Tableau de bord du cas RH

| Dimension | Résultat |
|-----------|---------|
| Niveau de risque | 🟠 Haut risque |
| Catégorie | Annexe III(4) — Emploi |
| Exception Art. 6(3) | Non (profilage) |
| Obligations | 6 (toutes au 02/12/2027) |
| FRIA requise | Oui (Art. 27) |
| AIPD requise | Oui (Art. 26(9)) |
| Information travailleurs | Oui (Art. 26(7)) |
| Conservation logs | 6 mois minimum (Art. 26(6)) |
| Amende maximale (PME) | 750 000 € |
| Amende maximale (non-PME) | 15 000 000 € |
| Prochaine échéance | 02/12/2027 (443 jours) |
| Validation requise | DPO / spécialiste audit conformité |

---

## 7. SÉCURITÉ ET RGPD

### 7.1 Traitement des données

| Propriété | Détail |
|-----------|--------|
| Données stockées | **Aucune** — le serveur est stateless |
| Apprentissage | **Aucun** — pas de modèle d'IA génératif |
| Persistance | **Aucune** — chaque requête est indépendante |
| Logs | Console uniquement (démarrage, erreurs) |
| Données personnelles | Non collectées par le serveur |

### 7.2 Conformité RGPD

| Architecture | Statut RGPD |
|-------------|-------------|
| Option A (interne) | Aucun sous-traitant — données restent dans l'organisation |
| Option B (Mistral) | Mistral AI = sous-traitant (art. 28 RGPD), hébergement UE, soumis au RGPD |

### 7.3 Recommandations de production

- Ajouter un **reverse proxy** (nginx/Caddy) pour TLS termination
- Restreindre le **CORS** aux domaines de l'organisation (défaut : `*`)
- Ajouter une **authentification** au niveau du proxy (token / header)
- Mettre en place un **rate limiting**

---

## 8. RÉFÉRENCES

| Référence | Lien |
|-----------|------|
| Règlement (UE) 2024/1689 | https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727 |
| Règlement (UE) 2026/1744 (Digital Omnibus) | https://eur-lex.europa.eu/ |
| Dépôt GitHub | https://github.com/faouzielouertani-arch/eu-ai-act-conformite |
| Mistral AI | https://mistral.ai |
| Le Chat (Mistral) | https://chat.mistral.ai |

---

## 9. AVERTISSEMENT JURIDIQUE

L'outil `eu-ai-act-conformite` v1.5.0 est un outil d'analyse de premier
niveau (« first-pass guidance »). Il applique la logique du Règlement (UE) 2024/1689
modifié par (UE) 2026/1744 de manière déterministe et reproductible.

Cet outil **ne constitue pas un avis juridique**. Pour une classification définitive,
des décisions de conformité ou une analyse d'obligations spécifiques, **une validation
humaine est requise** par un Délégué à la Protection des Données (DPO) ou un spécialiste
en audit de conformité de l'IA.

Le contenu EUR-Lex est réutilisé sous la Décision 2011/833/UE de la Commission
européenne : attribution préservée, sens non distordu.

---

*Document livré à Aurélie LAFFARGUE — Préparé par EL OUERTANI FAOUZI — 2025-09-15*
