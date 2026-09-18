# Récupération des sources — procédures d'appel

## 1. Passerelle Ansvar Gateway

Point de terminaison : https://gateway.ansvar.eu/mcp. Vérifier la connexion avec search_tool_functions ; en cas d'échec, redécouvrir le groupe d'outils.

### Découverte (toujours en premier)
- get_my_capabilities {} — tier, capacités, quotas.
- describe_capabilities — detail='summary' | 'full' ; section='sources' | 'addons' | 'tour' | identifiant de catégorie.
- list_workflow_types {} — registre en direct des flux de travail ; jamais deviner un identifiant.

### Quotas au tier gratuit (vérifiés le 16/09/2026)
| Outil | Quota quotidien |
|---|---|
| search, search_cve, search_by_product, search_ics_advisories | 100 chacun |
| discover_eu_legislation | 200 |
| get_provision + validate_citation + get_recital | 200 (budget partagé) |
| get_changes | 25 |
| get_cve_details, get_epss_score, check_kev_status, get_exploits, batch_search, get_ics_advisory | 500 chacun |

Concurrence : 3 appels. Flux de travail : 1 exécution/mois (threat_model, gap_analysis NIS2/DORA/CRA/AI Act, dpia). Compteurs réinitialisés à minuit UTC.

### Recherche de texte juridique — search
Portée obligatoire : au moins un de jurisdictions, frameworks, sectors ou sources. Au tier gratuit : une seule valeur par axe. Un concept par appel ; 2-3 synonymes d'un même concept joignables par OU majuscule. Lire meta.outcome et meta.recommended_action en cas d'échec strict. allow_broadening=true uniquement avec consentement de l'utilisateur. Une recherche sans résultat n'établit jamais l'absence d'obligation.

### Récupération d'un article — get_provision
Trois formes : (1) jurisdiction + law + article ; (2) canonical_ref rejoué tel quel depuis citation.lookup ; (3) law = corpus de normes + article natif. Comportement de transposition : jurisdiction d'État membre + règlement UE → disposition nationale de transposition ; passer jurisdiction='EU' pour le texte du règlement. Toujours récupérer le texte intégral avant citation longue.

### Renseignements de vulnérabilité
- get_cve_details {cve_id} — CVSS, CPE, KEV, EPSS, références.
- check_kev_status {cve_id} — la date renvoyée est la date d'ajout au catalogue.
- get_epss_score {cve_id} — probabilité à 30 jours et percentile.
- get_exploits {cve_id} — métadonnées seulement, jamais de code.
- search_cve — candidats à vérifier ; absence de résultat ≠ preuve d'absence.

### Veille et citations
get_regulatory_intelligence_status avant search_regulatory_updates ; get_changes (25/jour) ; get_data_freshness. Suivre meta.render_contract ; préserver les URL, éditeurs, licences et avertissements.

## 2. Repli — EUR-Lex et EULEX

| Instrument | CELEX |
|---|---|
| Règlement (UE) 2024/2847 (CRA) | 32024R2847 |
| Règl. d'exécution (UE) 2025/2392 | 32025R2392 |
| Directive (UE) 2022/2555 (NIS2) | 32022L2555 |
| Règlement (UE) 2016/679 (RGPD) | 32016R0679 |
| Règlement (UE) 2022/2554 (DORA) | 32022R2554 |

EUR-Lex : eurlex_search_documents, eurlex_get_document, eurlex_get_relations, eurlex_lookup_celex. EULEX : @eu/regulation/32024R2847/article/14. Vérification finale : ouvrir l'URL EUR-Lex via web_search.open_url avant de citer.

## 3. Repli vulnérabilités — recherche web

Uniquement si la passerelle est indisponible : NVD, catalogue KEV de CISA, EPSS de FIRST. Guidance CRA : FAQ Commission et ENISA, « guidance non liante ».

## 4. Discipline transversale

Un concept par requête ; signaler toute correspondance élargie ; rien de secret ou personnel ; distinguer « aucune disposition correspondante » et « récupération incomplète » ; restituer les citations avec leurs URL d'origine.
