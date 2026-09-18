# Action output — produire la note

## Input

L'ensemble des éléments des actions précédentes.

## Output

La note de permanence structurée, au format Cimade.

## Process

- **Structure.** Rappel des faits, problématiques juridiques, recherche documentaire (avec connecteurs et liens), analyse, stratégie et recours (juridiction, délais avec statut de vérification, suspensivité), actions immédiates, points de vigilance.
- **Traçabilité.** Chaque référence porte son connecteur et son lien, ou sa mention [NON VÉRIFIÉ].
- **Délais.** Signaler systématiquement tout délai de recours en cours ou expiré, avec son statut de vérification.
- **Vigilance.** Inclure les alertes : récépissé expiré, convocation préfecture, CRA, OQTF, suspension de droits sociaux.

## Test

| Case | Pass |
|---|---|
| Note finale produite | chaque référence porte connecteur et lien ou NON VÉRIFIÉ |
| Recours en cours | le délai restant est indiqué avec statut de vérification |
| Délai expiré | le point apparaît en tête des points de vigilance |
