
# Runecall

[![Runecall demo](https://img.youtube.com/vi/KDMeAB7pCYM/0.jpg)](https://www.youtube.com/watch?v=KDMeAB7pCYM)


Runecall is a filesystem-driven runner that uses **inotify** to watch your project
and execute language-specific Lua runners on file changes.

Everything is centralized under `~/.config/runes`.
Aliases are **not optional** and are installed automatically.

---

## Requirements

Runecall **requires inotify**. The watchers are Lua scripts, so you also need `lua` installed. The `runecall` summoner itself is a self-contained C binary.

### Linux

You must have `inotifywait` installed.

```bash
# Arch
sudo pacman -S inotify-tools

# Debian / Ubuntu
sudo apt install inotify-tools

# Fedora
sudo dnf install inotify-tools
```

Without `inotifywait`, Runecall will not work.

---

## Installation

Runes live in:

```
~/.config/runes
```

The `runecall` binary is installed to:

```
~/.local/bin/runecall
```

### Install

```bash
git clone https://github.com/neurorune/runes.git
cd runecall
chmod +x install.sh
./install.sh
```

The installer does **all required setup automatically**:

- Copies `runes/` into `~/.config/runes`
- Builds the `runecall` C binary
- Installs the binary to `~/.local/bin/runecall`
- Makes **all `.lua` files executable**
- Installs `inotify-tools` if missing
- Adds `~/.local/bin` to `PATH`
- Sources `~/.config/runes/rune_alias` into `.bashrc`

You do **not** need to manually add aliases.

Restart your shell or run:

```bash
source ~/.bashrc
```

---

## Aliases (automatic)

Aliases are defined in:

```
~/.config/runes/rune_alias
```

These are automatically sourced by the installer.

example aliases:

```bash
alias hydra='./.hydra/run.lua'        # C++
alias croc='./.croc/run.lua'          # C
alias waves='./.waves/run.lua'        # Python
alias ratatuya='./.ratatuya/run.lua'  # Rust
alias web='./.bun/run.lua'            # JavaScript
alias goose='./.goose/run.lua'        # Go
alias elix='./.elix/run.lua'          # Elixir
```

Users do **not** need to copy or edit these manually.

---

## Usage

Inside an empty project directory, summon a language:

```bash
runecall cpp
```

This copies a hidden language folder into the project:

```
.hydra/
└── run.lua
```

Then run:

```bash
hydra
```

The project is now watched using **inotify** and executes on file save.

---

## Supported Languages

| Language     | Summon Command |
|-------------|----------------|
| C           | `runecall c` |
| C++         | `runecall cpp` |
| Python      | `runecall python` |
| Rust        | `runecall rust` |
| JavaScript  | `runecall javascript` |
| Go          | `runecall go` |
| Elixir      | `runecall elixir` |

---

## Binary

`runecall` is a small C binary (`bin/runecall`). Drop it anywhere on
your `PATH` (e.g. `~/.local/bin/runecall`) — it does not need to live next to
the language folders. It reads the runes from `~/.config/runes`.

Rebuild it from source with:

```bash
gcc -O2 -Wall -Wextra -o runecall runecall.c
```

---

## Notes

- No editor plugins
- No manual alias setup
- No configuration files
- Everything is filesystem-driven
