# Bifrost Deployment on Render

This directory contains the Docker configuration and declarative JSON setup for deploying the [Bifrost](https://www.getbifrost.ai/) AI Gateway on Render.

## Files
- `Dockerfile`: Extends `maximhq/bifrost:latest`, copies `config.json` into `/app/data/config.json`, and exposes port `8080`.
- `config.json`: Declarative configuration for `gemini` and `groq` upstream providers, reading API keys and the virtual key dynamically from environment variables.
- `.env.example`: Template for required environment variables.

## Render Deployment Settings
- **Service Type**: **Web Service**
- **Environment / Runtime**: **Docker**
- **Region**: Any (choose region closest to your users or backend, e.g. Oregon/Frankfurt)
- **Branch**: `main` (in your bifrost repository or subfolder)
- **Root Directory**: `bifrost-deploy` (if in a monorepo) or repository root
- **Docker Command / Context**: Default (uses the `Dockerfile`)
- **Port**: `8080` (Render detects `EXPOSE 8080` or routes to port configured in `APP_PORT=8080`)

### Environment Variables on Render
Add the following under **Environment** in the Render Dashboard:
1. `GEMINI_API_KEY`: Your real Google AI Studio / Gemini API key
2. `GROQ_API_KEY`: Your real Groq API key (`gsk_...`)
3. `BIFROST_VK`: Your chosen virtual key string (e.g. `sk-bf-...` matching `BIFROST_VK` in TruthSync's `backend/.env`)
4. `APP_PORT`: `8080`
5. `APP_HOST`: `0.0.0.0`

## Persistence on Render Free Tier
- **Ephemeral Storage**: Render's free tier disks are ephemeral. Container spins down after 15 minutes of inactivity and restarts with a clean slate.
- **Config Survival**: Because `config.json` is baked into the Docker image, the entire provider setup, routing, and virtual key definition **survive 100% of restarts and sleep cycles without data loss**.
- Any runtime changes made through the web UI at runtime would be stored in the ephemeral SQLite database and lost on container restart. Keeping configuration in `config.json` guarantees consistent behavior.

