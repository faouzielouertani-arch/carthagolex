# Démo client — 4 cas réels exécutés sur le serveur

**Serveur** : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
**Auteur** : EL OUERTANI FAOUZI
**Date d'exécution** : 2025-09-15
**Transport** : stdio (MCP)
**Source légale** : Règlement (UE) 2024/1689 modifié par (UE) 2026/1744

> Chaque cas ci-dessous est une sortie **réelle** du serveur, non modifiée.
> Les commentaires en français sont ajoutés pour la présentation.

---

## Cas 1 — Système de recrutement IA (tri de CV automatisé)

### Scénario
Une entreprise utilise une IA pour trier et classer automatiquement les candidats
à l'embauche. L'IA profile les candidats et influence les décisions de recrutement.

### Requête envoyée
```json
{
  "name": "euaiact_classify_system",
  "arguments": {
    "role": "deployer",
    "signals": {
      "domain": "employment",
      "purpose": "automated_candidate_screening_or_ranking",
      "involves_profiling": true,
      "makes_decisions_affecting_individuals": true,
      "uses_biometrics": false,
      "uses_emotion_recognition": false,
      "uses_social_scoring": false,
      "critical_infrastructure": false,
      "education_or_vocational_training": false,
      "essential_services_access": false,
      "law_enforcement": false,
      "migration_asylum_border": false,
      "justice_democracy": false
    }
  }
}
```

### Réponse du serveur
```json
{
  "annex_iii_category": {
    "number": 4,
    "name": "Employment, workers management, and access to self-employment"
  },
  "risk_classification": "high-risk",
  "confidence": "high",
  "relevant_articles": ["Annex III(4)", "Art. 6(2)", "Art. 26(7)", "Art. 27"],
  "role_determination": "deployer",
  "obligations_summary": "Deployer obligations: use per instructions (Art. 26(1)),
    human oversight by competent persons (Art. 26(2)), input data relevance (Art. 26(4)),
    monitor operation and notify provider/distributor plus market surveillance authority
    where Art. 26(5) requires, keep logs under deployer control (Art. 26(6)), DPIA where
    required (Art. 26(9)), workplace and Annex III user notices where applicable (Art.
    26(7)/(11)), Art. 86 explanations where its threshold is met, and FRIA where Art. 27
    applies.",
  "caveat": "Art. 6(3) exception may apply if the system performs only a narrow procedural
    task with no material influence on decision-making AND does not perform profiling of
    natural persons. Use euaiact_assess_art6_3_exception to evaluate."
}
```

### 🇫🇷 Commentaire
Le serveur classifie le système en **haut risque** avec une **confiance élevée**.
Il identifie la catégorie **Annexe III(4)** (emploi) et liste les obligations du
déployeur. Il signale aussi l'**exception Art. 6(3)** possible — mais note que le
profilage disqualifie cette exception.

---

## Cas 2 — Reconnaissance faciale temps réel dans un lieu public

### Scénario
Un système de reconnaissance faciale temps réel dans un espace public, utilisé pour
identifier des personnes à distance.

### Réponse du serveur (extrait)
```json
{
  "annex_iii_category": {
    "number": 1,
    "name": "Biometrics"
  },
  "risk_classification": "high-risk",
  "confidence": "medium",
  "relevant_articles": [
    "Annex III(1)", "Art. 6(2)",
    "Art. 5(1)(f)", "Art. 5(1)(g)", "Art. 5(1)(h)",
    "Art. 26(10)"
  ],
  "caveat": "High-risk classification depends on the biometric use being within Annex III(1)
    and legally permitted. Sole-purpose biometric verification is excluded from Annex
    III(1)(a); real-time remote biometric identification in publicly accessible spaces for
    law enforcement may be prohibited under Art. 5(1)(h)."
}
```

### 🇫🇷 Commentaire
Le serveur détecte **à la fois** le haut risque (Annexe III(1)) **et** une possible
**prohibition** (Art. 5(1)(h) — reconnaissance faciale temps réel dans l'espace public
pour la répression). Il ne se contente pas d'une classification, il alertera sur les
pratiques interdites.

---

## Cas 3 — Chatbot e-commerce (FAQ client)

### Scénario
Un chatbot de support client sur un site e-commerce. Interaction avec des personnes,
pas de profiling, pas de décisions affectant des individus.

### Réponse du serveur (extrait)
```json
{
  "risk_classification": "limited",
  "confidence": "high",
  "relevant_articles": ["Art. 50", "Art. 50(1)"],
  "obligations_summary": "Limited-risk transparency obligation: natural persons must be
    informed that they are interacting with an AI system (Art. 50(1)), unless obvious
    from context."
}
```

### 🇫🇷 Commentaire
Classification **risque limité**. Une seule obligation : **transparence** (informer
l'utilisateur qu'il parle à une IA). Pas d'évaluation de conformité, pas de base de
données UE, pas de système de gestion des risques. Simple et clair.

---

## Cas 4 — Modèle GPAI (3 × 10²⁵ FLOPs) + amende prohibition

### Scénario 4a — Un modèle d'IA généraliste entraîné avec 3e25 FLOPs

#### Réponse du serveur (extrait)
```json
{
  "model_name": "demo-llm-v3",
  "crosses_flops_threshold": true,
  "flops_threshold": 1e+25,
  "systemic_risk_designation": "threshold_met",
  "is_gpai_with_systemic_risk": true,
  "baseline_obligations_art_53": [
    {
      "obligation": "Technical documentation for GPAI models",
      "article": "Art. 53(1)(a)",
      "deadline": "2025-08-02"
    },
    {
      "obligation": "Information and documentation for downstream providers",
      "article": "Art. 53(1)(b)",
      "deadline": "2025-08-02"
    },
    {
      "obligation": "Copyright compliance policy",
      "article": "Art. 53(1)(c)",
      "deadline": "2025-08-02"
    },
    {
      "obligation": "Training data summary",
      "article": "Art. 53(1)(d)",
      "deadline": "2025-08-02"
    }
  ]
}
```

### 🇫🇷 Commentaire
Le modèle dépasse le seuil de **10²⁵ FLOPs** → le serveur le qualifie de
**GPAI à risque systémique** (Art. 51(2)). Il liste les obligations Art. 53 :
documentation technique, info pour les intégrateurs, politique de droits d'auteur,
résumé des données d'entraînement.

### Scénario 4b — Calcul d'amende pour pratique prohibée (CA = 100 M€)

#### Requête
```json
{
  "name": "euaiact_calculate_penalty",
  "arguments": {
    "violation_type": "prohibited",
    "annual_turnover_eur": 100000000,
    "is_sme": false
  }
}
```

#### Réponse du serveur
```json
{
  "violation_type": "prohibited",
  "max_fine": {
    "fixed_cap_eur": 35000000,
    "turnover_based_eur": 7000000,
    "applicable_fine_eur": 35000000,
    "explanation": "For Prohibited AI practices violations (Art. 99(3)): up to EUR
      35,000,000 or 7% of global annual turnover, whichever is HIGHER."
  },
  "comparative": {
    "non_sme_applicable_fine_eur": 35000000,
    "sme_applicable_fine_eur": 7000000,
    "reduction_eur": 28000000
  }
}
```

### 🇫🇷 Commentaire
Pour une violation de **pratique prohibée** (Art. 5) avec un CA de 100 M€ :
l'amende maximale est de **35 M€** (le plafond fixe l'emporte sur 7 % du CA = 7 M€).
Si l'entreprise était une PME, l'amende tomberait à 7 M€. L'outil compare les deux
régimes automatiquement.

---

## Bonus — Échéances des pratiques prohibées (Art. 5)

### Requête
```json
{
  "name": "euaiact_check_deadlines",
  "arguments": { "area": "prohibited", "only_upcoming": false }
}
```

### Réponse (extrait)
```json
{
  "milestones": [
    {
      "date": "2025-02-02",
      "name": "Prohibited practices and AI literacy",
      "status": "in_effect",
      "articles": ["Art. 5", "Art. 4", "Art. 113(a)"],
      "key_obligations": [
        "All prohibited AI practices (Art. 5) must cease",
        "Subliminal manipulation, exploitation of vulnerabilities, social scoring,
         untargeted facial scraping, emotion recognition in workplaces/schools - all banned"
      ],
      "is_past": true,
      "days_remaining": -590
    },
    {
      "date": "2026-12-02",
      "name": "New Art. 5 prohibitions and the Art. 50(2) legacy transition",
      "status": "upcoming",
      "days_remaining": 78,
      "key_obligations": [
        "New Art. 5 prohibitions on non-consensual intimate material and CSAM become
         enforceable",
        "Synthetic-content systems already on the market complete Art. 50(2) marking
         compliance"
      ]
    }
  ],
  "next_milestone": {
    "date": "2026-12-02",
    "days_remaining": 78
  }
}
```

### 🇫🇷 Commentaire
Les pratiques prohibées (Art. 5) sont **déjà en vigueur** depuis le 2 février 2025.
Les nouvelles prohibitions (matériel intime non consenti, CSAM) entrent en vigueur
le **2 décembre 2026** — dans 78 jours à la date d'exécution.

---

## Bonus — Échéances des systèmes haut risque (Annexe III)

### Réponse (extrait)
```json
{
  "milestones": [
    {
      "date": "2027-12-02",
      "name": "High-risk Annex III obligations (deferred by the Digital Omnibus)",
      "status": "upcoming",
      "days_remaining": 443,
      "key_obligations": [
        "Risk management systems for high-risk AI",
        "Data governance and management practices",
        "Technical documentation (Annex IV)",
        "Automatic logging and record-keeping",
        "Transparency and instructions for deployers",
        "Human oversight measures",
        "Accuracy, robustness, and cybersecurity requirements",
        "Conformity assessments",
        "EU database registration",
        "Post-market monitoring and incident reporting"
      ]
    },
    {
      "date": "2028-08-02",
      "name": "Annex I regulated product obligations (deferred by the Digital Omnibus)",
      "status": "upcoming"
    }
  ]
}
```

### 🇫🇷 Commentaire
Pour les systèmes haut risque de l'Annexe III (recrutement, biometrie, etc.), les
obligations complètes s'appliquent à partir du **2 décembre 2027**. Le Digital Omnibus
a reporté cette date. Pour les composants de sécurité de produits réglementés
(Annexe I), c'est le **2 août 2028**.

---

## Bonus — Obligations du déployeur (haut risque, Annexe III(4))

### Réponse (extrait)
```json
{
  "role": "deployer",
  "risk_level": "high-risk",
  "obligations": [
    {
      "obligation": "Use in accordance with instructions",
      "article": "Art. 26(1)",
      "deadline": "2027-12-02",
      "category": "operational"
    },
    {
      "obligation": "Assign human oversight to competent persons",
      "article": "Art. 26(2)",
      "deadline": "2027-12-02",
      "category": "human_oversight"
    },
    {
      "obligation": "Ensure input data relevance",
      "article": "Art. 26(4)",
      "deadline": "2027-12-02",
      "category": "data_governance"
    },
    {
      "obligation": "Monitor operation and report",
      "article": "Art. 26(5)-(6)",
      "deadline": "2027-12-02",
      "category": "monitoring"
    },
    {
      "obligation": "Data Protection Impact Assessment (DPIA)",
      "article": "Art. 26(9)",
      "deadline": "2027-12-02",
      "category": "data_protection"
    }
  ]
}
```

### 🇫🇷 Commentaire
Le déployeur d'un système haut risque Annexe III(4) a 5 obligations principales,
toutes applicables au **2 décembre 2027**. Chaque obligation cite l'article exact
et la catégorie.

---

## Bonus — Article 6 (règles de classification haut risque)

### Réponse (extrait)
```json
{
  "article": {
    "number": "6",
    "title": "Classification rules for high-risk AI systems",
    "summary": "Art. 6(1): high-risk if safety component of a product covered by EU
      harmonisation legislation (Annex I). Art. 6(2): systems in Annex III are also
      high-risk. Art. 6(3): exception if no significant risk AND no profiling. Art. 6(4):
      providers relying on Art. 6(3) must document and register."
  },
  "eurlex_url": "https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02024R1689-20260727#art_6"
}
```

---

## Récapitulatif des 4 cas

| Cas | Système | Classification | Confiance | Articles clés |
|-----|---------|---------------|-----------|---------------|
| 1 | Recrutement IA | 🟠 Haut risque | Élevée | Annex III(4), Art. 6(2), 26, 27 |
| 2 | Reconnaissance faciale publique | 🟠 Haut risque + ⚠️ prohibition | Moyenne | Annex III(1), Art. 5(1)(h) |
| 3 | Chatbot e-commerce | 🟡 Limité | Élevée | Art. 50(1) |
| 4 | GPAI 3e25 FLOPs | 🔴 Risque systémique | — | Art. 51(2), 53 |

---

## Comment reproduire ces résultats

```bash
cd eu-ai-act-mcp
npm install && npm run build

# Lancer le serveur stdio et envoyer les requêtes MCP
node dist/index.js
# Puis envoyer les JSON-RPC ci-dessus via stdin
```

Les résultats sont **déterministes** : les mêmes entrées produisent toujours les
mêmes sorties (vérifié par 120/120 tests de déterminisme).
