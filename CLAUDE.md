# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Development
bin/dev                        # Start all processes (web, vite, tailwind, queue)

# Tests
bin/rails test                 # Run full test suite
bin/rspec spec/path/to_spec.rb # Run a single spec file

# Linting
bin/rubocop                    # Check style
bin/rubocop --auto-correct     # Auto-fix offenses
```

Always lint and run tests after every change and make sure they pass.

## Architecture

**Outbox** is a Rails 8.1 app that exposes an HTTP API for queuing and sending templated transactional emails via Mailgun. It includes a web UI for managing templates, providers, and delivery logs.

### Multi-tenancy
All resources belong to a `Workspace`. The `ApplicationController` sets `@workspace` from the subdomain/param and all queries are scoped to it.

### Authentication
- **Web UI**: HTTP Basic auth via `HTTP_BASIC_AUTH_USERNAME` / `HTTP_BASIC_AUTH_PASSWORD` env vars
- **Send API**: Bearer token via `OUTBOX_API_KEY` credential/env var

### Email flow
1. `POST /send/message` (handled by `Send::MessagesController`) creates a pending `Delivery` record
2. `DeliverEmailJob` picks it up via Solid Queue (database-backed, no Redis)
3. `MailgunAdapter` sends the email via the HTTP API
4. `MessageRenderer` renders the subject/body using Shopify Liquid templating with caller-supplied variables

### Key models
- `Message` — email template with a slug; has many `MessageVariant`s
- `MessageVariant` — locale/variant-specific subject + html_body + text_body (Liquid templates)
- `Delivery` — record of a send attempt; status: pending → sent/failed; stores variables/cc/bcc as JSON
- `Provider` — Mailgun credentials (api_key, sending_domain, sender) scoped to a Workspace

### Tech stack
- **Database**: SQLite in all environments (via `sqlite_crypto` for UUIDs)
- **Queue**: Solid Queue
- **Frontend**: Hotwire (Turbo + Stimulus), Vite, Tailwind CSS, Flowbite components
- **Testing**: RSpec + FactoryBot

## Conventions

### Rails
- No business logic in controllers or views — use models or service objects
- No `after_commit` for side effects — use jobs
- Never use `update_column` (skips validations)
- Generate migrations with `rails generate migration`, never write by hand; prefer `change` over `up`/`down`; mark irreversible migrations with `irreversible!`

### Views
- Use [Flowbite components](https://flowbite-components.substancelab.com) for UI
- Use Rails I18n for all interface text; prefer `translate(".key")` over `t(".key")`

### Frontend
- Stimulus + Turbo over SPAs; keep JS thin
- JS lives in `app/javascript/`
- Do not add npm packages without discussion

### RuboCop style (`.rubocop.yml`)
- Hash rockets (`=>`) for hash literals
- Double-quoted strings
- Trailing commas in multi-line collections
- Always lint the code after each change and make sure they pass


### Testing
- RSpec + FactoryBot; prefer `build_stubbed` over `build`/`create` where possible
- Always run the tests after each change and make sure they pass
