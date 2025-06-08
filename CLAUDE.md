# CLAUDE.md - AI Assistant Context

## Project Overview
This is a Docker-based development environment optimized for AI-assisted development with Claude.

## Key Features
- **Alpine Linux**: Lightweight base image
- **Playwright**: Browser automation with Chromium, Firefox, and WebKit
- **Development Tools**: Node.js, Python, Go, Rust, Git, GitHub CLI
- **AI-Friendly Tools**: ripgrep, fd, bat, fzf, jq, yq, httpie
- **Shell**: Fish with Starship prompt (Zsh also available)
- **Editor**: Neovim
- **Web Server**: Caddy for reverse proxy and local development
- **Session Management**: tmux for persistent sessions

## Useful Commands
- `ll` - List files with details (alias for exa -la)
- `cat` - View files with syntax highlighting (alias for bat)
- `find` - Fast file search (alias for fd)
- `rg` - Fast content search with ripgrep
- `gh` - GitHub CLI for repository management
- `http` - HTTPie for API testing
- `jq` - JSON processing
- `yq` - YAML processing
- `entr` - Run commands when files change
- `direnv` - Per-directory environment variables

## Playwright Testing
```bash
# Python
python -m playwright codegen https://example.com

# JavaScript
npx playwright codegen https://example.com
```

## Development Workflow
1. Code changes are automatically detected by entr
2. Use direnv for project-specific environment variables
3. tmux sessions persist across container restarts
4. Xvfb provides headless display for browser automation

## File Structure
- `/home/developer/workspace/` - Main development directory
- `/home/developer/.config/` - Configuration files
- `.envrc` - direnv configuration (if present)
- `.init.sh` - Custom initialization script (if present)

## Testing Commands
- `npm test` - Run Node.js tests
- `pytest` - Run Python tests
- `go test` - Run Go tests
- `cargo test` - Run Rust tests

## Git Configuration
Git is pre-configured with developer credentials. Update `.env` file to customize.

## Best Practices for AI Assistance
1. Use ripgrep (`rg`) for fast code searches
2. Use `tree` to understand project structure
3. Use `bat` for syntax-highlighted file viewing
4. Use `jq`/`yq` for structured data manipulation
5. Use `httpie` for API testing and debugging