# Theme selector

Branch: `feature/theme-selector`. Base: `main`.

Adds a theme dropdown to the top bar and setup screen with Dark (today's look), Green Light, Pink Light, Greyscale, System, and Custom. Green Light, Pink Light, and Greyscale reuse palettes from the dashboard (`web-app/dashboard/Dashboard-lydia/wwwroot/index.html`): Green Light is its working-copy default, Pink Light is its default on `origin/main`. The choice persists in `localStorage` and applies before first paint.

## Phase 1: Chrome colors come from CSS variables

What exists today:
- `index.html` `:root` defines `--bg`, `--panel`, `--text`, `--muted`, `--accent`, `--ok`, `--warn`.
- About 25 other colors are hardcoded in the `<style>` block: `.btn` (`#2a2a36`, `#3a3a48`, `#34344a`), `#setup .status` (`#20202a`), `#top select` (`#20202acc`), `#conn` and `#conn.off`, `.badge`, `.badge.done`, `.badge.pending`, `#rail button` (`#ffffff1f`, `#ffffff33`, `#ddd`), `#toast` (`#000d`, `#333`), the `#top` gradient (`#000c`), and `.bm` and `.btn.primary` text (`#fff`).
- The video area (`.frame`, `.tap::after`, `.pstatus`) sits on top of players and is intentionally dark in every theme.
- The bookmarklet toast (inline `style` strings at `bookmarklet()`) runs on the Pluralsight page, not in this app.

Contract / behavior:
- New variables, with Dark values equal to the current hardcoded ones: `--on-accent`, `--control`, `--control-hover`, `--border`, `--well`, `--field`, `--chip`, `--rail`, `--rail-hover`, `--rail-label`, `--scrim`, `--toast-bg`, `--toast-fg`, `--toast-border`, `--ok-bg`, `--ok-fg`, `--bad-bg`, `--bad-fg`, `--done-bg`, `--done-fg`, `--pending-bg`, `--pending-fg`.
- After this phase, hex and `rgb()` colors appear in the `<style>` block only inside `:root`, the video-area rules, and the `text-shadow` or `box-shadow` values.
- Rendering in Dark is unchanged.

Tasks:
- [x] Add the variables to `:root` with current values
- [x] Replace each hardcoded chrome color with its variable

Acceptance:
- Loading the feed with the Dark values looks identical to before (compare against the current server's page)
- A search of the `<style>` block for hex colors outside the allowed spots returns nothing

## Phase 2: Theme selector with Green Light, Pink Light, Greyscale, System

What exists today:
- Settings live in the `store` helper, key prefix `psfeed:`, JSON values.
- `#app` is hidden until Pluralsight data arrives, so the top bar is not visible on the setup screen.
- The keydown handler skips events whose target is inside `select, input`.

Contract / behavior:
- `<html data-theme="...">` holds the resolved palette: `dark` (default), `green`, `pink`, `greyscale`, or `custom`. The saved choice can also be `system`.
- `green`, `pink`, and `greyscale` take their core colors from the dashboard palettes: `--background` to `--bg`, `--backdrop` to `--panel`, `--accent` to `--text`, `--header` to `--accent`, `--highlight` to `--control`, `--secondary` to `--control-hover`. Each theme sets every variable from Phase 1.
- `system` resolves to `dark` or `green` from `prefers-color-scheme` and follows live changes. Phase 3 adds `custom` to the valid values.
- The choice is stored as `psfeed:theme`. A small inline script in `<head>` reads it and sets `data-theme` before the stylesheet paints, so there is no flash.
- A `select#theme` in `#top` and a second `select` in the setup `.box` stay in sync. Changing either applies the theme at once.
- An unknown stored value falls back to `dark`.
- Each palette sets CSS `color-scheme` (`dark` or `light`) so native controls (select, color input, scrollbars) match.

Tasks:
- [x] Add `[data-theme]` palette blocks for `green`, `pink`, `greyscale`
- [x] Add the head script and the `system` resolver
- [x] Add both selects and one `applyTheme` function that updates `data-theme` and both selects, with storage written on change
- [x] Add a toast on change, like the speed button

Gate: Judge the Green Light, Pink Light, and Greyscale looks in the feed and setup screen. Bring screenshots or the live page.

Acceptance:
- Switching themes updates the whole page, including the rail, badges, connection pill, and toast
- Reload keeps the theme with no visible flash
- `system` follows an OS or DevTools emulated color-scheme change
- J, K, Space, and O still work after using the select

## Phase 3: Custom theme and docs

What exists today:
- No color inputs exist in the app.

Contract / behavior:
- Choosing `custom` shows an Edit button beside the select. It opens a small panel with four color inputs: background, panel, text, accent.
- Every other variable is derived from those four with `color-mix(in srgb, ...)` in the `[data-theme="custom"]` block, so the panel never needs more than four values.
- Values are stored as `psfeed:customColors` (`{bg, panel, text, accent}`) and applied as inline custom properties on `<html>`. The head script applies them too.
- A Reset button restores the starting values (the Dark palette).
- Invalid or missing stored colors fall back to the Dark values.
- `README.md` gets a short Themes section covering the selector, the available themes, and how to add one (a new `[data-theme]` block setting every variable).

Tasks:
- [x] Add the Edit button and four-input panel with live preview
- [x] Persist and restore custom colors, including in the head script
- [x] Add the README Themes section

Acceptance:
- Editing a color changes the page live and survives reload
- Reset returns to the Dark look
- The README describes the current behavior and nothing stale

## Verify

- Syntax: parse the page's `<script>` with Node (see the state file command)
- Static: a search of the `<style>` block for hex colors outside the allowed spots
- Live: serve with `python -I serve.py`, open `http://127.0.0.1:8765`, reveal the feed from DevTools by clearing `hidden` on `#app` and setting `hidden` on `#setup`, and check each theme
- There is no test suite or CI in this repo, and none is added

## Open questions by story

- **Theme list:** none blocking

## Deferred

- Theming the bookmarklet toast and button, which render on the Pluralsight page
- Per-theme video frame colors
