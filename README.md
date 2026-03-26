# OpenClaw Sprite Builder

A web app that provisions [Sprites](https://sprites.dev) running [OpenClaw](https://github.com/openclaw/openclaw) with one click.

## What it does

The builder serves a form where users provide their Sprites API token and LLM API keys. On submit, it:

1. Creates a new sprite via the Sprites API
2. Installs OpenClaw inside the sprite
3. Writes config with a keep-alive wrapper (so the sprite stays running between requests)
4. Registers an OpenClaw gateway service on port 18789
5. Returns the sprite URL with the gateway ready to use

## Deploy your own

Create a sprite and run the setup script:

```bash
sprite create openclaw-builder
sprite exec openclaw-builder -- bash -c '
  git clone https://github.com/theoctopusperson/openclaw-sprite-builder.git ~/openclaw-builder
  cd ~/openclaw-builder
  bash setup.sh
'
```

Or if you're already inside a sprite:

```bash
git clone https://github.com/theoctopusperson/openclaw-sprite-builder.git ~/openclaw-builder
cd ~/openclaw-builder
bash setup.sh
```

The builder will be available at your sprite's URL.

## How it works

- **Server** (`server.js`) — Express app with a `/api/deploy` SSE endpoint that orchestrates sprite creation and setup
- **UI** (`public/index.html`) — Dark-themed deploy form with real-time progress streaming
- **Setup script** (`setup.sh`) — Installs deps, registers the sprite service, and starts the builder

The setup script generated for each OpenClaw sprite includes:
- `sprite-keep-running.sh` — Registers a user task to keep the sprite running while OpenClaw is up
- Idempotent config merging — safe to re-run without losing existing settings
- API keys persisted in `~/.profile` so they survive reboots

## License

MIT
