# Action analyze — appliquer les critères

## Input

Les faits qualifiés (action facts) et les références vérifiées (action verify).

## Output

Une analyse en deux volets : légalité externe (si une décision est contestée) et légalité interne (appréciation du fond).

## Process

- **Première demande.** Évaluer les critères positifs : durée de présence, liens familiaux en France, insertion, intérêt supérieur de l'enfant, santé. Mobiliser la référence partagée `criteres-vepf.md` sans la reformuler.
- **Refus contesté.** Analyser la motivation, l'erreur manifeste d'appréciation, la proportionnalité au regard de l'article 8 CEDH, l'intérêt supérieur de l'enfant.
- **Risque d'éloignement.** Évaluer l'impact d'une OQTF ou d'un placement en rétention sur la stratégie d'analyse.
- **Neutralité.** Rester factuel, sans promesse de résultat.

## Test

| Case | Pass |
|---|---|
| Enfants scolarisés depuis 5 ans | l'intérêt supérieur de l'enfant est analysé |
| Refus préfectoral non motivé | le moyen de motivation est identifié |
| Critère santé invoqué | le texte malade est cité avec statut de vérification |
