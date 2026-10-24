# Présentation commerciale — Outil d'analyse de conformité EU AI Act

**Destinataire** : Aurélie LAFFARGUE
**Produit** : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
**Auteur** : EL OUERTANI FAOUZI
**Licence** : MIT

> **⚠️ Validation humaine requise** : Les résultats produits par cet outil constituent une analyse de premier niveau. Toute classification définitive et tout rapport de conformité opposable doivent être **validés par un DPO ou un spécialiste audit de conformité**.

---

## 1. Le problème client

Depuis le 1er février 2025, le **Règlement (UE) 2024/1689** (AI Act) est entré en vigueur.
Toute entreprise qui **développe, déploie ou utilise** un système d'IA en UE doit :

- **Classifier** chaque système IA selon 4 niveaux de risque
- **Appliquer des obligations** spécifiques (documentation, supervision, transparence…)
- **Respecter des échéances** précises (2 août 2026, 2 décembre 2027, 2 août 2028)
- Risquer des **amendes jusqu'à 35 M€ ou 7 % du chiffre d'affaires mondial**

**Le problème** : la plupart des entreprises ne savent pas où elles en sont.
Elles ne savent pas si leurs systèmes sont « haut risque », quelles obligations s'appliquent,
ni quelles sont leurs dates butoirs.

---

## 2. La solution : un moteur d'analyse réglementaire automatisé

L'outil n'est **pas un chatbot** qui « parle » AI Act. C'est un **moteur déterministe**
qui applique la logique du règlement à un système IA décrit et renvoie une analyse
ancrée dans le texte officiel.

### Ce que l'outil fait concrètement

| Fonction | Résultat pour le client |
|----------|------------------------|
| **Classification** | Niveau de risque : inacceptable / élevé / limité / minimal + catégorie Annexe III |
| **Articles applicables** | Liste des articles du règlement qui s'appliquent + lien EUR-Lex officiel |
| **Obligations** | Liste détaillée par rôle (fournisseur / déployeur) avec date d'application |
| **Échéances** | Calendrier de conformité selon le type de système |
| **Amendes** | Calcul du montant maximal encouru selon le type de violation et le CA |
| **Checklist Annexe IV** | Liste des éléments de documentation technique à produire |
| **Exception Art. 6(3)** | Vérifie si un système Annexe III peut sortir du haut risque |
| **GPAI** | Analyse du seuil de risque systémique (1e25 FLOPs) |
| **Questions libres** | Réponses ancrées dans le règlement sur l'AI Act |

---

## 3. Argumentaire — 3 phrases

> **L'AI Act est en vigueur.** Toute entreprise qui développe, déploie ou utilise une IA
> en UE doit se conformer, sous peine d'amendes jusqu'à 35 M€ ou 7 % du CA mondial.
>
> **Notre outil analyse votre système IA** et vous dit précisément : votre niveau de risque,
> les articles qui s'appliquent, vos obligations légales, vos échéances et le montant des
> amendes en cas de manquement.
>
> **Vous repartez avec un rapport ancré dans le texte officiel du règlement** — pas une
> opinion. Chaque conclusion cite l'article exact et le lien EUR-Lex correspondant.

---

## 4. Cas d'usage métier

### Usage 1 — Audit de conformité express
> « Décrivez-nous votre système IA. Vous recevez en 5 minutes : niveau de risque,
> articles applicables, obligations, échéances et amendes potentielles. »

### Usage 2 — Cartographie du portefeuille IA
> Un client a 10, 20, 50 systèmes IA en interne. On passe chacun dans le classifieur.
> On obtient une **matrice de risque** : lesquels sont haut risque, lesquels juste
> transparence, lesquels prohibés. Priorisation immédiate des actions.

### Usage 3 — Calendrier de conformité
> « Votre système est haut risque ? Voici vos dates butoirs : enregistrement base UE,
> évaluation de conformité, mise en conformité avant le 2 décembre 2027. »

### Usage 4 — Simulateur d'amendes
> « Si vous ne vous conformez pas, l'amende maximale est de 15 M€ ou 3 % de votre CA. »
> Argument commercial direct pour déclencher l'action.

### Usage 5 — Checklist technique livrable
> Pour un client haut risque : la checklist Annexe IV complète (documentation technique,
> gestion des risques, logs, supervision humaine) → document de travail concret.

---

## 5. Les 4 niveaux de risque — support visuel

| Niveau | Ce que ça signifie | Exemples | Sanction |
|--------|-------------------|----------|---------|
| 🔴 **Inacceptable** | IA **interdite** en UE | Scoring social, manipulation subliminale, reconnaissance faciale temps réel dans l'espace public (répression) | **Interdiction** |
| 🟠 **Haut risque** | Obligations lourdes (doc, conformité, supervision) | Recrutement IA, scoring crédit, éducation, biometrie, justice | **15 M€ ou 3 % CA** |
| 🟡 **Limité** | Obligation de transparence uniquement | Chatbot, deepfake, reconnaissance d'émotions | **8 M€ ou 1,5 % CA** |
| 🟢 **Minimal** | Code de conduite volontaire | Filtre anti-spam, IA de jeu vidéo | Aucune sanction |

---

## 6. Pourquoi cet outil plutôt qu'un autre

| Critère | Notre outil | Chatbot IA générique |
|---------|-------------|----------------------|
| **Ancrage légal** | Cite les articles exacts + lien EUR-Lex | Texte approximatif sans citation |
| **Déterminisme** | Mêmes entrées = mêmes sorties (120/120 tests) | Réponses variables, non reproductibles |
| **Classification structurée** | Oui, avec catégorie Annexe III | Non, texte libre |
| **Échéances à jour** | Inclut le Digital Omnibus 2026/1744 | Souvent obsolètes |
| **Calcul d'amendes** | Oui, selon Art. 99/101 | Non |
| **Audit possible** | Sorties reproductibles et défendables | Non auditable |
| **Verification** | 490 tests + 10 gates de vérification | Aucun |

---

## 7. Limites à communiquer honnêtement

- **Orientation de premier niveau** (« first-pass guidance ») — pas un avis juridique
- Pour une classification **définitive**, un juriste / DPO est nécessaire
- L'outil cadre et accélère, il ne remplace pas le conseil juridique
- L'outil le dit lui-même dans chaque réponse

---

## 8. Suite proposée

1. **Voir la démo** → fichier `DEMO-CLIENT.md` (4 cas réels exécutés)
2. **Tester avec vos propres systèmes** → lancer le serveur en local ou sur Railway
3. **Générer un rapport** → fichier `RAPPORT-MODELE.md` (modèle réutilisable)
4. **Déployer en production** → fichier `CONFIG-DEPLOIEMENT.md`

---

## 9. Sources légales

- **Règlement (UE) 2024/1689** — AI Act original
- **Règlement (UE) 2026/1744** — Digital Omnibus sur l'IA (modifications)
- **EUR-Lex** : https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727
- Réutilisation du contenu EUR-Lex sous la Décision 2011/833/UE

---

*EL OUERTANI FAOUZI — eu-ai-act-conformite*
*Validation humaine requise par un DPO ou spécialiste audit de conformité*
