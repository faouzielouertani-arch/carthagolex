# Configuration de déploiement — EU AI Act MCP Server

**Serveur** : `eu-ai-act-conformite` (basé sur `eu-ai-act-mcp` v1.5.0, MIT)
**Auteur** : EL OUERTANI FAOUZI
**Transports disponibles** : stdio (local) / HTTP streamable (cloud)
**Prérequis** : Node.js ≥ 20

---

## 1. Build et préparation (commun à tous les déploiements)

```bash
git clone https://github.com/faouzielouertani-arch/eu-ai-act-conformite.git
cd eu-ai-act-mcp
npm install
npm run build
```

Le build génère le dossier `dist/` contenant :
- `dist/index.js` → serveur **stdio**
- `dist/http.js` → serveur **HTTP** (port via `PORT`, défaut 3000)

---

## 2. Déploiement local — stdio (Claude Desktop / Cursor)

### 2.1 Claude Desktop

Fichier de config :
- **macOS** : `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows** : `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "eu-ai-act": {
      "command": "node",
      "args": ["/chemin/absolu/vers/eu-ai-act-mcp/dist/index.js"]
    }
  }
}
```

Redémarrez Claude Desktop. Le serveur apparaît dans les outils MCP disponibles.

### 2.2 Cursor

Fichier `.cursor/mcp.json` à la racine du projet ou dans la config globale :

```json
{
  "mcpServers": {
    "eu-ai-act": {
      "command": "node",
      "args": ["/chemin/absolu/vers/eu-ai-act-mcp/dist/index.js"]
    }
  }
}
```

### 2.3 Via npx (sans clone local)

```json
{
  "mcpServers": {
    "eu-ai-act": {
      "command": "npx",
      "args": ["-y", "@eu-ai-act-conformite (fork local)"]
    }
  }
}
```

---

## 3. Déploiement HTTP local

```bash
cd eu-ai-act-mcp
npm run build
PORT=3000 node dist/http.js
```

- **Endpoint MCP** : `http://localhost:3000/mcp`
- **Health check** : `http://localhost:3000/health`

### Test du health check
```bash
curl http://localhost:3000/health
# → {"status":"ok","server":"eu-ai-act-conformite","version":"1.5.0"}
```

---

## 4. Déploiement Railway

Railway utilise le **Procfile** déjà présent dans le dépôt :
```
web: node dist/http.js
```

### Étapes

1. **Forkez** le dépôt sur GitHub : `https://github.com/faouzielouertani-arch/eu-ai-act-conformite`

2. Sur [Railway](https://railway.app), créez un **New Project** → **Deploy from GitHub repo**

3. Sélectionnez votre fork. Railway détecte le `Procfile` automatiquement.

4. Railway exécute :
   ```bash
   npm install        # détecté via package.json
   npm run build     # ⚠️ Ajouter un build step si nécessaire
   node dist/http.js  # via Procfile
   ```

   **Important** : ajoutez une **build command** dans Railway :
   ```
   npm install && npm run build
   ```
   Et le **start command** :
   ```
   node dist/http.js
   ```

5. **Variable d'environnement** : Railway fournit automatiquement `$PORT`.
   Ne le définissez pas manuellement — Railway l'injecte.

6. Railway attribue une URL publique : `https://votre-app.up.railway.app`
   - Endpoint MCP : `https://votre-app.up.railway.app/mcp`
   - Health : `https://votre-app.up.railway.app/health`

### railway.json (optionnel, config explicite)

Créez un fichier `railway.json` à la racine :
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "npm install && npm run build"
  },
  "deploy": {
    "startCommand": "node dist/http.js",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 3
  }
}
```

---

## 5. Déploiement Smithery

Le projet inclut déjà `smithery.yaml` :
```yaml
name: eu-ai-act-conformite-server
description: "EU AI Act compliance MCP server..."
version: 1.5.0
command: npx
args:
  - -y
  - "@eu-ai-act-conformite (fork local)"
envs: {}
```

### Étapes

1. Publiez le paquet sur npm (si vous contrôlez le paquet) :
   ```bash
   npm login
   npm publish --access public
   ```

2. Sur [Smithery](https://smithery.ai), soumettez le serveur via le `smithery.yaml`.

3. Smithery instancie le serveur en mode stdio via `npx @eu-ai-act-conformite (fork local)`.

---

## 6. Déploiement Docker

Le projet inclut déjà un **Dockerfile** multi-stage :
```dockerfile
FROM node:22-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src/ src/
RUN npm run build

FROM node:22-slim
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=build /app/dist/ dist/
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "dist/http.js"]
```

### Build et run

```bash
# Build de l'image
docker build -t eu-ai-act-mcp .

# Run sur le port 3000
docker run -p 3000:3000 --name eu-ai-act eu-ai-act-mcp

# Run sur un autre port (ex: 8080)
docker run -p 8080:3000 -e PORT=3000 --name eu-ai-act eu-ai-act-mcp
```

### Test
```bash
curl http://localhost:3000/health
# → {"status":"ok","server":"eu-ai-act-conformite","version":"1.5.0"}
```

### docker-compose.yml (optionnel)

```yaml
version: "3.9"
services:
  eu-ai-act-mcp:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "node", "-e", "fetch('http://localhost:3000/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"]
      interval: 30s
      timeout: 5s
      retries: 3
```

```bash
docker compose up -d
```

---

## 7. Déploiement Fly.io / Render / autres PaaS

Le serveur HTTP est standard (Node.js HTTP). N'importe quelle PaaS qui exécute Node.js fonctionne :

### Fly.io
```bash
fly launch          # détecte le Dockerfile
fly deploy
```

### Render
- **Build Command** : `npm install && npm run build`
- **Start Command** : `node dist/http.js`
- Render fournit `$PORT` automatiquement.

---

## 8. Endpoints et variables d'environnement

### Variables
| Variable | Défaut | Description |
|----------|--------|-------------|
| `PORT` | `3000` | Port d'écoute du serveur HTTP |
| `NODE_ENV` | — | Mettre `production` en prod |

### Endpoints HTTP
| Méthode | Chemin | Description |
|---------|--------|-------------|
| `POST` | `/mcp` | Endpoint MCP (Streamable HTTP) |
| `GET` | `/health` | Health check JSON |
| `OPTIONS` | `*` | Préflight CORS (CORS activé `*`) |

### Format MCP
- Le serveur utilise le transport **Streamable HTTP** (stateless)
- Chaque requête est indépendante (pas de session)
- CORS activé pour `*` (compatible Smithery proxy)

---

## 9. Vérification post-déploiement

### Health check
```bash
curl https://votre-domaine/health
# → {"status":"ok","server":"eu-ai-act-conformite","version":"1.5.0"}
```

### Test MCP (initialize)
```bash
curl -X POST https://votre-domaine/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test","version":"1.0.0"}}}'
```

### Liste des outils
```bash
curl -X POST https://votre-domaine/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
```

---

## 10. Sécurité et production

### Recommandations
- Le serveur est **read-only** (aucune donnée stockée, aucun état)
- En production, ajoutez un **reverse proxy** (nginx/Caddy) pour :
  - TLS termination
  - Rate limiting
  - Authentification (header/token)
- CORS est configuré sur `*` — restreignez-le à vos domaines en production si nécessaire

### Limites connues
- Mode **stateless** : pas de session persistante entre requêtes
- Aucune authentification intégrée → ajouter au niveau du proxy

---

*Guide de déploiement — Aurélie LAFFARGUE — EL OUERTANI FAOUZI*
*Validation humaine requise par un DPO ou spécialiste audit de conformité*
