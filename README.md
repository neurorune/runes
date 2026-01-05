# Runecall

Runecall is a filesystem-driven runner that uses **inotify** to watch your project
and execute language-specific Lua runners on file changes.

Everything is centralized under `~/.config/runes`.
Aliases are **not optional** and are installed automatically.

---

## Requirements

Runecall **requires inotify**.

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

Everything is installed into:

```
~/.config/runes
```

### Install

```bash
[git clone https://github.com/YOURNAME/runecall](https://github.com/neurorune/runes.git)
cd runecall
chmod +x install.sh
./install.sh
```

The installer does **all required setup automatically**:

- Copies `runes/` into `~/.config/runes`
- Makes `runecall` executable
- Makes **all `.lua` files executable**
- Installs `inotify-tools` if missing
- Adds `~/.config/runes` to `PATH`
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

Example aliases:

```bash
alias hydra='./.hydra/run.lua'        # C++
alias croc='./.croc/run.lua'          # C
alias waves='./.waves/run.lua'        # Python
alias ratatuya='./.ratatuya/run.lua'  # Rust
alias web='./.bun/run.lua'            # JavaScript
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

---

## Notes

- No editor plugins
- No manual alias setup
- No configuration files
- Everything is filesystem-driven
