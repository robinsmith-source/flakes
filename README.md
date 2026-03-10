# NixOS Configuration

Multi-machine NixOS flake — currently configured for:

| Host | Hardware |
|------|----------|
| `laptop` | Lenovo Ideapad 5 Pro 14ARH7 (Ryzen 6000 / Radeon 680M) |
| `desktop` | Ryzen 7 7800X3D + Radeon RX 7800XT |

**Stack:** CachyOS LTS kernel · niri · Noctalia shell · Alacritty · zsh · Neovim (LazyVim) · home-manager

---

## Prerequisites

- A bootable **NixOS minimal ISO** (download from [nixos.org](https://nixos.org/download))
- Internet access on the target machine
- This repository cloned (or copied) onto the target machine

---

## Installation

### 1 — Boot the NixOS installer

Boot the target machine from the NixOS minimal ISO. The rest of these steps are run
inside the live environment as root.

### 2 — Partition and format the disk

Replace `/dev/nvme0n1` with your actual disk (`lsblk` to find it).

```bash
# Create a GPT partition table with a 1 GiB EFI partition and a root partition.
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GiB 100%

mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L nixos  /dev/nvme0n1p2
```

> **Tip:** if you prefer btrfs or LVM, adjust accordingly. The
> `hardware-configuration.nix` generated in step 4 will reflect whatever layout
> you create here.

### 3 — Mount

```bash
mount /dev/disk/by-label/nixos  /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT   /mnt/boot
```

### 4 — Generate hardware configuration

```bash
nixos-generate-config --root /mnt
```

This writes `/mnt/etc/nixos/hardware-configuration.nix`. Copy it into this repo:

```bash
# From the machine where this repo lives — or do it after cloning in step 5.
cp /mnt/etc/nixos/hardware-configuration.nix hosts/laptop/hardware-configuration.nix
```

### 5 — Clone this repository

```bash
nix-shell -p git
git clone <your-repo-url> /mnt/etc/nixos/config
cd /mnt/etc/nixos/config
```

### 6 — Personalise

Edit these files before the first build:

| File | What to change |
|------|----------------|
| `flake.nix` | `username = "robin"` → your username |
| `modules/nixos/common.nix` | `time.timeZone` and `i18n.extraLocaleSettings` |
| `modules/home/development.nix` | `programs.git.userName` and `userEmail` |
| `config/niri/config.kdl` | keyboard `layout`, monitor output name, `scale` |
| `hosts/laptop/hardware-configuration.nix` | replace placeholder with output from step 4 |

> **Finding your monitor output name:** after first boot, run `niri msg outputs`
> and update the output block in `config/niri/config.kdl`.

### 7 — First install

```bash
nixos-install --flake /mnt/etc/nixos/config#laptop --root /mnt
```

When prompted, set the **root** password. You will set your user password in the
next step.

### 8 — Reboot and set your user password

```bash
reboot
# After logging in as root:
passwd <your-username>
```

---

## Post-install

### Enable pnpm via corepack

`corepack` ships with Node.js but pnpm must be activated once per user:

```bash
corepack enable pnpm
```

After that, pnpm is managed per-project via `packageManager` in `package.json`,
or globally with `corepack install -g pnpm@latest`.

### Noctalia shell

Noctalia starts automatically as a systemd user service after login.
Check its status with:

```bash
systemctl --user status noctalia-shell
```

Settings live in `modules/home/default.nix` under `programs.noctalia-shell.settings`.
Full option reference: <https://docs.noctalia.dev>

### Tailscale

Authenticate your machine to your Tailscale network:

```bash
sudo tailscale up
```

---

## Day-to-day commands

All commands assume you are in the flake directory (`/etc/nixos/config` or wherever
you keep it).

| Command | Effect |
|---------|--------|
| `sudo nixos-rebuild switch --flake .#laptop` | Apply configuration changes |
| `sudo nixos-rebuild test --flake .#laptop` | Apply without making it the boot default |
| `sudo nixos-rebuild boot --flake .#laptop` | Stage for next reboot only |
| `nix flake update` | Update all inputs to latest |
| `nix flake update nixpkgs` | Update only nixpkgs |
| `sudo nix-collect-garbage -d` | Delete all old generations |
| `sudo nix-collect-garbage --delete-older-than 7d` | Delete generations older than 7 days |
| `nix store optimise` | Deduplicate the store |
| `nixos-rebuild list-generations` | List all available generations |

The shell aliases `rebuild`, `upgrade`, and `cleanup` are also available in zsh
(defined in `modules/home/shell.nix`).

### Rolling back

```bash
# Boot into the previous generation from the bootloader, or:
sudo nixos-rebuild switch --rollback
```

---

## Adding a new machine

1. Create `hosts/<hostname>/default.nix` and `hosts/<hostname>/hardware-configuration.nix`
   (use the existing hosts as a template).

2. Add one line to `flake.nix`:

   ```nix
   nixosConfigurations = {
     laptop  = mkSystem { hostname = "laptop"; };
     desktop = mkSystem { hostname = "desktop"; };
     newbox  = mkSystem { hostname = "newbox"; };   # ← add this
   };
   ```

3. Run `nixos-install --flake .#newbox` on the new machine.

Any host-specific overrides (kernel params, extra services, etc.) go only in
`hosts/<hostname>/default.nix`; everything else is shared automatically.

---

## Repository structure

```
flake.nix                        # Inputs, outputs, mkSystem helper
hosts/
  laptop/
    default.nix                  # Laptop-specific settings + user definition
    hardware-configuration.nix   # Generated by nixos-generate-config
  desktop/
    default.nix
    hardware-configuration.nix
modules/
  nixos/
    common.nix                   # Shared NixOS: audio, BT, fonts, nix settings
    cachyos.nix                  # CachyOS LTS kernel, zram, Plymouth
    desktop/
      default.nix                # niri, Noctalia, greetd, portals, polkit
    hardware/
      amd.nix                    # amdgpu, microcode, Vulkan, ROCm
  home/
    default.nix                  # home-manager root, GTK theme, Noctalia config
    shell.nix                    # Alacritty, zsh, starship, fzf, zoxide, CLI tools
    neovim.nix                   # nixvim + LazyVim + typst (tinymist)
    apps.nix                     # bitwarden, chrome, spotify, discord
    development.nix              # nodejs+corepack, python+uv, git, direnv
config/
  niri/
    config.kdl                   # niri keybindings, layout, output settings
```
