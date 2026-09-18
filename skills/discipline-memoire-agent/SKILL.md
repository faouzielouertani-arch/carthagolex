---
name: discipline-memoire-agent
description: "Enseigne quand relire la mémoire de long terme avant d'agir et quand y sauvegarder décisions, corrections et échecs durables. À utiliser quand un outil de mémoire est connecté mais peu sollicité, quand l'utilisateur se plaint que l'assistant oublie préférences, conventions ou décisions entre sessions, ou pour mettre en place une mémoire persistante de projet. Fonctionne avec tout support : dossier de fichiers Markdown, serveur MCP local, ou service géré."
category: ai-agents
license: CC0-1.0 (adapté de davepoon/buildwithclaude, skill agent-memory-discipline)
---

# Discipline de mémoire de l'agent

Connecter un outil de mémoire ne suffit pas à ce qu'un agent l'utilise. Les outils s'enregistrent, la session se déroule, et rien n'est rappelé ni sauvegardé. Ce skill fournit la pièce manquante : des règles permanentes sur le moment de lire la mémoire et le moment d'écrire.

Il est indépendant du support : tout ce qui suit fonctionne aussi bien avec un dossier de fichiers Markdown, un serveur MCP local ou un service hébergé.

## Relire avant d'agir

Lire la mémoire **avant** chacune de ces actions, pas après :

- commencer un travail sur un projet déjà touché ;
- choisir une bibliothèque, un motif ou un outil ;
- rédiger des tests, des commits ou de la documentation, là où des conventions s'appliquent ;
- répondre à « comment fait-on d'habitude X ici » ;
- toute demande formulée par l'utilisateur comme « encore », « comme la dernière fois », « comme convenu ».

Ne pas relire pour : les questions factuelles ponctuelles, l'arithmétique, ou tout ce qui est entièrement spécifié dans le message courant. La relecture coûte un appel d'outil et du contexte ; ne le dépenser que quand il rapporte.

## Sauvegarder après avoir agi

Écrire dans la mémoire **après** chacun de ces événements, pas avant :

- une décision durable prise par l'utilisateur (choix d'outil, de convention, d'architecture) ;
- une correction apportée par l'utilisateur à un comportement antérieur de l'agent ;
- un échec instructif : une approche essayée et abandonnée, avec la raison ;
- une préférence exprimée sur la forme des livrables (format, langue, ton, structure) ;
- la création d'un nouvel artefact durable (dépôt, skill, canvas) et son emplacement.

Ne pas sauvegarder : les faits ponctuels re-trouvables ailleurs, les états transitoires de session, les demandes d'un coup.

## Règles de rédaction

1. Une note par fait, avec un titre explicite — pas de notes fourre-tout.
2. Dater chaque note.
3. Inclure la raison de la décision, pas seulement la décision — c'est elle qui permet de juger si la note s'applique encore.
4. Mettre à jour la note existante plutôt que d'en créer une doublon.
5. Une note contredite par la session courante est corrigée ou supprimée, jamais laissée en conflit.

## Détection des défaillances de mémoire

Signes qu'un agent n'applique pas cette discipline :

- l'utilisateur répète une préférence déjà exprimée ;
- l'agent réexplique une convention déjà établie ;
- l'agent propose une approche déjà essayée et écartée ;
- l'utilisateur dit « tu ne te souviens pas ? ».

Chacun de ces signaux déclenche une relecture immédiate de la mémoire et une sauvegarde du point oublié.

## Test

| Cas | Réussite |
|---|---|
| « Continue comme la dernière fois » | la mémoire est lue avant toute action |
| L'utilisateur corrige un choix fait en session précédente | la correction est sauvegardée avec sa raison |
| Question factuelle ponctuelle | aucune lecture ni écriture de mémoire |
| Nouveau dépôt créé | son existence et son emplacement sont sauvegardés |
