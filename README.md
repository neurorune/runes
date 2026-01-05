
# Runecall

Runecall is a filesystem-driven runner that uses **inotify** to watch your project
and execute language-specific Lua runners on file changes.

It is editor-agnostic and works entirely from the terminal.

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
git clone https://github.com/YOURNAME/runecall
cd runecall
chmod +x install.sh
./install.sh
```

The installer will:

- Copy `runes/` into `~/.config/runes`
- Make `runecall` executable
- Make **all `.lua` files executable**
- Add `~/.config/runes` to `PATH`

Restart your shell or run:

```bash
source ~/.bashrc
```

After that, `runecall` works from anywhere.

---

## How It Works

Inside a project directory, you summon a language:

```bash
runecall cpp
```

This copies a hidden language folder into the project:

```
.hydra/
└── run.lua
```

The `run.lua` script uses **inotify** to watch files and execute logic on save.

---

## Optional Aliases

For convenience, you may add:

```bash
alias hydra='./.hydra/run.lua'       # C++
alias croc='./.croc/run.lua'         # C
alias waves='./.waves/run.lua'       # Python
alias ratatuya='./.ratatuya/run.lua' # Rust
alias web='./.bun/run.lua'           # JavaScript
```

These are optional.

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

- No editor plugins required
- No configuration files required
- Everything is driven by filesystem events
