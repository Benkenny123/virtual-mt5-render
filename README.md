# Virtual MT5 on Render

Browser-accessible MetaTrader 5 terminal running 24/7 on Render via Docker + Wine + noVNC.

## How it works
- The Docker image (`fortesenselabs/metatrader`) bundles MT5, Wine, and a noVNC web interface.
- Render builds this repo, exposes it at a public URL, and keeps it running around the clock (paid plan; free tier sleeps after ~15 min).
- A persistent disk (`mt5-data` at `/root/.wine`) preserves your MT5 login, EAs, and config across redeploys.

## Auto-deploy
Every push to `main` triggers a deploy via GitHub Actions → Render API.

### Required GitHub secrets
Settings → Secrets and variables → Actions:
- `RENDER_API_KEY` — your Render API key (Render → Account Settings → API Keys)
- `RENDER_SERVICE_ID` — service ID from your Render service URL (e.g. `srv-xxxx`)

## Manual deploy
1. Create a free/starter Web Service on Render from this repo (Docker runtime).
2. Set `PORT=8000` and a `VNC_PASSWORD`.
3. Attach a 10 GB disk mounted at `/root/.wine`.
4. Open the live URL, log into MT5 with your broker, upload EAs to `MQL5/Experts`, and enable **Algo Trading**.

## Caveats
- Render only exposes HTTP(S) — custom non-HTTP TCP listeners won't receive inbound traffic.
- Use a **paid** instance so the terminal never sleeps.
