# Action facts — collecter les faits

## Input

Les informations transmises par le bénévole (fiche permanence, pièces du dossier).

## Output

Une liste de faits qualifiés, horodatés, avec les incertitudes signalées.

## Process

- **Recenser.** Lister les éléments : nationalité, date d'entrée, situation familiale, enfants, ressources, logement, titres antérieurs, refus antérieurs, mesures d'éloignement en cours ou passées.
- **Dater.** Établir la durée de présence ininterrompue et les dates clés (mariage, naissance, installation).
- **Signaler.** Marquer toute incertitude ou information manquante décisive.
- **Qualifier.** Identifier les faits susceptibles de fonder la vie privée et familiale (durée, liens, insertion, santé, scolarité des enfants).

## Test

| Case | Pass |
|---|---|
| Dossier avec enfants scolarisés | la scolarité figure dans les faits qualifiés |
| Date d'entrée inconnue | l'incertitude est explicitement signalée |
| OQTF en cours | le fait apparaît en tête de liste |
