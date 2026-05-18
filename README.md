# Homebrew tap for [`aq`](https://github.com/pirj/aq)

`aq` is a QEMU wrapper to run Alpine Linux VMs on macOS (Apple Silicon, HVF) and Linux x86_64 (KVM).

## Install

```sh
brew install pirj/aq/aq
```

Brew will install `qemu`, `tio`, `socat`, `coreutils`, `wget`, and `gnupg` as dependencies.

### macOS (Apple Silicon)

That's it. `aq new myvm && aq start myvm && aq console myvm` should just work.

### Linux

In addition to the brew packages, you'll need:

* **KVM access** — your user must be able to read+write `/dev/kvm`:

  ```sh
  sudo usermod -aG kvm $USER   # log out and back in
  [ -r /dev/kvm ] && [ -w /dev/kvm ] && echo "KVM OK"
  ```

* **System OVMF firmware** — not packaged by brew on Linux. On Debian/Ubuntu:

  ```sh
  sudo apt-get install -y ovmf
  ```

* **netcat-openbsd** for `nc -U` unix-socket support (most distros already ship it).

## Upgrading

```sh
brew update && brew upgrade aq
```

## License

MIT (this tap and the formula). `aq` itself is also MIT — see https://github.com/pirj/aq.
