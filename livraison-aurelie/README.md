# Livraison — Outil d'analyse de conformité EU AI Act

Destinataire : **Aurélie LAFFARGUE**
Date : 2025-09-15
Serveur : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
Auteur : **EL OUERTANI FAOUZI**

> **⚠️ Validation humaine requise** : Toute classification définitive et tout rapport de conformité opposable doivent être **validés par un DPO ou un spécialiste audit de conformité**.

---

## Contenu de la livraison

Ce dossier contient 4 livrables :

| Fichier | Description |
|---------|-------------|
| `PRESENTATION.md` | Présentation commerciale : ce qu'est l'outil, à quoi il sert, l'argumentaire client |
| `DEMO-CLIENT.md` | Démo avec 4 cas réels exécutés sur le serveur (sorties brutes et commentées) |
| `RAPPORT-MODELE.md` | Modèle de rapport de conformité réutilisable pour un client |
| `CONFIG-DEPLOIEMENT.md` | Configuration de déploiement : Railway, Smithery, Docker, MCP local |

---

## Démarrage rapide

```bash
# Sur votre machine
git clone https://github.com/faouzielouertani-arch/eu-ai-act-conformite.git
cd eu-ai-act-conformite
npm install
npm run build

# Mode stdio (Claude Desktop / Cursor)
npm start

# Mode HTTP (Railway / Smithery)
PORT=3000 npm run start:http
# Endpoint MCP : http://localhost:3000/mcp
# Health check : http://localhost:3000/health
```

---

## Résumé exécutif

L'outil analyse un système IA décrit et renvoie :

1. **La classification de risque** AI Act (inacceptable / élevé / limité / minimal)
2. **Les articles applicables** avec liens EUR-Lex officiels
3. **Les obligations** par rôle (fournisseur / déployeur) avec dates d'application
4. **Les échéances de conformité** selon le type de système
5. **Le calcul des amendes** encourues (jusqu'à 35 M€ ou 7 % du CA)

Toutes les sorties sont **ancrées dans le texte officiel** du Règlement (EU) 2024/1689,
modifié par le Règlement (EU) 2026/1744 (Digital Omnibus sur l'IA).

**Avertissement** : orientation de premier niveau, pas un avis juridique. Pour une
classification définitive, consulter un juriste / DPO.
