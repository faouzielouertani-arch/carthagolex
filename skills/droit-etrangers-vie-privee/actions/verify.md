# Action verify — vérifier les textes

## Input

La liste des références à citer, issue de l'analyse préalable.

## Output

Chaque référence avec son statut : vérifiée (connecteur + lien) ou [NON VÉRIFIÉ].

## Process

- **Identifier le sujet de fond.** Jamais un numéro d'article de mémoire : partir de la notion (vie privée et familiale, étranger malade).
- **Interroger.** OpenLegi CarthagoLex en priorité pour le texte en vigueur, numérotation courante.
- **Confirmer.** Open URL sur la page Légifrance renvoyée, pour le texte exact.
- **Étendre.** LibreJustice pour la jurisprudence CE/CEDH ; EUR-Lex pour la CJUE.
- **Marquer.** [NON VÉRIFIÉ — à confirmer par le bénévole sur Légifrance] si le connecteur échoue ou ne renvoie rien d'exploitable.

## Test

| Case | Pass |
|---|---|
| Article L.423-23 cité | le lien Légifrance confirmé apparaît dans la note |
| Connecteur indisponible | la mention NON VÉRIFIÉ est présente |
| Fiche interne citant L.313-11 7° | la correspondance avec la numérotation courante est signalée |
