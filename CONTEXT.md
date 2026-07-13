# Dotfiles — Domain Glossary

## Terms

### Stow package
A top-level directory in this repo whose internal path structure mirrors `$HOME`
(e.g. `common/.tmux.conf` → `~/.tmux.conf`). Running `stow -t ~ <package>` symlinks
its contents into `$HOME`. This repo has exactly three packages: `common`, `linux`,
`mac`. A file's package membership *is* the mechanism that decides whether it's
installed on a given machine — there is no separate OS-detection logic and no
`.stow-local-ignore` carve-out list.

### common (package)
Files/configs that are installed identically on both Linux and Mac. Being "common"
is a claim about installation, not just file similarity — a file only belongs here
if stowing it on either OS is correct and safe (see decisions below for borderline
cases like tool availability).

### linux / mac (packages)
Files/configs installed only on the named OS. Holds both files with no counterpart
on the other OS, and files that are conceptually "the same setting" but whose
content/format differs enough per OS that they can't be unified (each OS's version
lives in its own package under the same relative path). These packages are grown
organically — a tool's config is added only once that tool is actually configured on
that OS; equivalents are never stubbed out preemptively for a tool not yet in use.

## Decisions

- **2026-07-10** — Repo restructured into three Stow packages (`common`, `linux`,
  `mac`) replacing the single-root-package + `.stow-local-ignore` model. Rationale:
  the old model needed an ever-growing ignore-list to keep non-mirrored files out of
  the symlink tree; per-OS packages make membership explicit and let installation be
  `stow -t ~ common linux` (or `common mac`) with no exceptions list.

- **2026-07-10** — Repo is assumed to always be cloned to `~/dotfiles`. Any file that
  needs to reference the repo's own location (e.g. fish sourcing) may hardcode this
  path rather than detect it.

- **2026-07-10** — `symlinks.sh` auto-detects OS via `uname -s` and runs
  `stow -vv -t ~ common linux` (Linux) or `stow -vv -t ~ common mac` (Darwin) — one
  command, no argument to remember. Default behavior lets Stow fail loudly on
  pre-existing conflicting files at the target path (no silent overwrite). A
  `-f`/`--force` flag on `symlinks.sh` opts into passing Stow's `--adopt`, which
  pulls the pre-existing real file into the repo and replaces it with a symlink —
  available for deliberate first-run cleanup, never the default. `-vv` verbosity is
  always kept regardless of `-f`.

- **2026-07-10** — VS Code's macOS config directory
  (`~/Library/Application Support/Code/User`) is **not** managed via a Stow package
  symlink. Superseded the earlier plan (a symlink tracked inside `mac/`) because
  Stow's `--adopt` cannot reconcile "target is a real directory" against "package
  wants a symlink" — it aborts the whole run rather than replacing the directory.
  Instead, `symlinks.sh` links `settings.json` and `keybindings.json` individually
  with plain `ln -s` after the `mac` package is stowed, guarded by the same
  `-f`/`--force` flag: without it, an existing real file at either path is left
  alone and reported as skipped; with it, the existing file is removed and replaced
  with a symlink into `common/.config/Code/User/`.

- **2026-07-10** — Repo-governance files (`.gitignore`, `README.md`, `CONTEXT.md`)
  stay at repo root, un-stowed — they configure this git repo, not `$HOME`, so they
  don't belong inside any of the three Stow packages.

- **2026-07-10** — OS detection is always via `uname` (no fish builtin
  `$fish_kernel_name` available) — `if test (uname) = Darwin` in fish files,
  `if-shell "uname | grep -q Darwin"` in tmux — consistent mechanism across both
  in-place rule-2-exception branches.

- **2026-07-10 (superseded same day)** — `.tmux.conf`'s shell setting uses the bare
  command `fish` rather than an absolute path. **Wrong**: tmux's `default-shell`
  validation requires an absolute path starting with `/` and rejects a bare command
  name outright ("not a suitable shell: fish"), regardless of `$PATH`. Replaced with
  `run-shell 'tmux set-option -g default-shell "$(command -v fish)"'` at the top of
  `.tmux.conf` — resolves the real absolute path at config-load time on whichever OS
  it runs on (Homebrew Apple-Silicon vs Intel prefix, Arch's `/usr/bin/fish`, etc.),
  no per-OS branching needed.

- **2026-07-10** — `.config/fish/fish_variables` (fish's auto-generated universal
  variable store, containing this machine's baked-in absolute paths) is removed from
  the repo and gitignored — it's regenerated state, not authored config, and must not
  be carried across machines.

- **2026-07-10** — `~/private.sh` is intentionally untracked, machine-local secrets
  sourced by `config.fish` (or its `conf.d` replacement) — guarded with a
  `test -f ~/private.sh` existence check rather than an unconditional `source`,
  since the file won't exist until created by hand per machine. (Originally
  documented as `~/private.fish`; corrected 2026-07-13 to match the file that
  actually exists on disk — see below for why it's bash, not fish, syntax.)

- **2026-07-13** — `~/private.sh` is bash syntax (it sources a much larger,
  externally-maintained bash environment file with variable assignments,
  `$(...)`, bash-style `unset`, etc. — not something to hand-translate to fish).
  fish's own `source` can't parse it, so `config.fish` calls a new
  `source_bash_env` function (`common/.config/fish/conf.d/source_bash_env.fish`)
  instead: it runs the script in a real `bash` subshell, diffs `env` before and
  after, and `set -gx`s whatever changed. Chosen over installing a plugin manager
  + `bass` (the standard fish solution to this exact problem) to avoid adding a
  new dependency for a ~10-line problem — matches this repo's existing style of
  small hand-rolled functions in `conf.d` (`jump.fish`, `take.fish`) over pulling
  in a plugin ecosystem.

- **2026-07-10** — `common/add_path.fish` splits into `linux/` and `mac/` copies
  (rule 1): Linux keeps its `/mnt/vault2/shell/trash` mount path; Mac adds
  `/opt/homebrew/opt/trash/bin` to `$PATH`, since Homebrew's `trash` formula (Hasseg,
  keg-only) is not symlinked into `/opt/homebrew` by default.

- **2026-07-10** — `common/safe_rm.fish`'s `rm` override branches its trash-CLI
  invocation in place via `if test (uname) = Darwin` (rule 2 exception): Mac's
  Homebrew `trash` (Hasseg) takes `trash $argv`, while Linux's AUR `trashy` takes
  `trash put $argv` (git-style subcommand) — different CLIs behind the same package
  name, single-line difference, not worth duplicating the whole file for.

- **2026-07-10** — `common/.config/fish/conf.d/tmux.fish`'s `update_tmux_title`
  strips a leading `-` from the command name before comparing/using it, and passes
  `--` to the `string replace` call that does so. Root cause: once tmux's
  `default-shell` was fixed to launch fish via an absolute path (see the superseded
  decision above), fish now starts as tmux's login shell, and login shells are
  reported by `ps -o comm=` with a leading dash (`-fish` instead of `fish`) — a
  convention, not a fish bug. Without stripping it, the `if test "$cmd" = "fish"`
  check failed, and the literal string `-fish` was passed to `tmux rename-window`,
  which parsed it as an unknown flag (`-f`). The strip itself needed `string replace
  -r '^-' '' -- $cmd` (with `--`) because `string replace`'s own option parser
  otherwise treats a leading-dash argument as a flag too — same class of bug one
  layer down.

- **2026-07-10** — For files that are almost entirely identical across OSes but
  contain a handful of OS-divergent lines: default to **whole-file duplication**
  (separate copy in `linux/` and `mac/`), not runtime OS-detection or file-splitting.
  Exception: tools with native syntax for OS-branching in place (tmux `if-shell`,
  fish `if test (uname) = Darwin`) may keep a single copy in `common/` using that
  syntax. This exception does not apply to formats with no conditional syntax (e.g.
  plain JSON) — those always duplicate under rule 1.

- **2026-07-12** — Per-OS machine bootstrap lives in two new repo-root scripts,
  `init-mac.sh` and `init-linux.sh` — not inside the `mac`/`linux` Stow packages,
  since anything under those packages gets symlinked into `$HOME` and these scripts
  are meant to run once, not live at a `$HOME` path. Consistent with the existing
  "repo-governance files stay at root, un-stowed" rule above, extended to
  machine-setup scripts. Each script installs that OS's packages, runs whatever
  non-interactive customization is scriptable, and calls `./symlinks.sh` last (stowing
  requires the packages symlinks depend on — e.g. `fish` — to already be installed).
  The two scripts are fully independent (no shared sourced helper file), matching the
  repo's existing duplication-over-abstraction convention for OS-divergent logic.

- **2026-07-12** — `init-mac.sh`/`init-linux.sh` absorb every *non-interactive*
  manual setup step previously documented in the README (package install, `chsh -s
  $(which fish)`, cloning `tpm`, and — Linux only — the Omarchy backgrounds `rm`+`cp`,
  including its destructive `rm`, which is accepted as a deliberate part of running
  the init script rather than kept manual). The one step left manual is tmux's
  `prefix + I` plugin install, which requires an interactive tmux session with a human
  present and has no scriptable equivalent — each init script echoes a reminder for
  it after running, and README documents it as the remaining manual step.

- **2026-07-12** — Both init scripts accept an optional `-f`/`--force` flag and
  forward it verbatim to `./symlinks.sh` at the end, rather than hardcoding
  `--force` or omitting the flag entirely. Preserves `symlinks.sh`'s existing
  "loud failure by default, `--adopt` only on request" safety property (see decision
  above) while still letting a deliberate first-run pass it through in one command.

- **2026-07-12** — Each script fails loudly and exits before doing anything if its
  OS's main package manager isn't installed, rather than attempting to bootstrap it:
  `init-mac.sh` checks for `brew` (message links to https://brew.sh); `init-linux.sh`
  checks for both `pacman` and `yay` (`yay`'s message links to the Arch wiki's AUR
  helpers page). The `pacman` check exists even though Arch/Omarchy always ships it,
  specifically to give a clear "wrong OS" message (no link — there's nothing to
  install) if someone runs `init-linux.sh` on a non-Arch Linux distro, rather than
  failing confusingly deeper into the script.

- **2026-07-12** — The `tpm` clone and `chsh` call in both init scripts are guarded
  (`[ -d ~/.tmux/plugins/tpm ] || git clone ...`; only run `chsh` if the shell isn't
  already `fish`) so that re-running the init script on an already-set-up machine is
  safe — `git clone` into an existing directory fails outright, and `chsh` otherwise
  reprompts for a password every run even when there's nothing to change.

- **2026-07-12** — `mise` is reserved for language/runtime version management
  (`node`, `ruby`, `bun` in `common/.config/mise/config.toml`). Standalone CLI tools
  (e.g. `lazygit`, added for tmux's new `bind g` popup) are installed via the OS
  package manager instead (`Brewfile` on Mac, `pacman-packages.txt` on Linux — it's
  in Arch's `extra` repo, no AUR needed) even when mise has a plugin/backend for
  them. Keeps a single install path per OS (`brew bundle` / `init-linux.sh`) rather
  than needing both `mise install` and a package-manager install depending on the
  tool.

- **2026-07-12** — `gh` (GitHub CLI) is added to `pacman-packages.txt` as
  `github-cli` — it was already in `Brewfile` for Mac but missing from Linux
  provisioning entirely, so `init-linux.sh` had no path to installing it.

- **2026-07-12** — `gh-dash` (a `gh` extension, not a standalone binary) is
  installed via `gh extension install dlvhdr/gh-dash`, added identically to both
  `init-mac.sh` and `init-linux.sh` right after each script's package-manager step.
  This departs from the `lazygit`/`mise` precedent above ("standalone CLI tools go
  through the OS package manager") because gh-dash doesn't fit that mold: it has no
  Homebrew formula at all, and while an AUR package exists, upstream's only
  documented install path is the `gh extension` mechanism. Using `gh extension
  install` uniformly on both OSes gives one install command instead of two
  divergent ones, and the command is already idempotent (exits 0, warns if already
  installed) so no guard is needed — matching the unguarded style of the `brew
  bundle`/`pacman -S --needed` lines it sits next to. No `config.yml` is tracked
  under `common/.config/gh-dash/` yet — same "grow organically" rule as the
  `linux`/`mac` packages: add one once there's an actual customization to make. No
  tmux popup keybind was added either, for the same reason.

- **2026-07-13** — `common/.config/fish/conf.d/aliases.fish`'s `e` (env | fzf |
  clipboard) alias became a function branching `if test (uname) = Darwin` (rule 2
  exception, same shape as `safe_rm.fish`): Mac pipes to `pbcopy`, Linux to
  `wl-copy`. `xclip` was removed from `pacman-packages.txt` and replaced with
  `wl-clipboard` — Linux provisioning targets Hyprland (Wayland; see
  `linux/.config/hypr/`), and `xclip` only reaches the clipboard via an X11/XWayland
  bridge that isn't guaranteed present, while `wl-copy` talks to the Wayland
  clipboard natively. `xclip` had no other references in the repo, so the swap was
  a clean removal, not a duplication.
