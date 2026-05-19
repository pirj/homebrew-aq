class Aq < Formula
  desc "QEMU wrapper to run Alpine Linux VMs on macOS and Linux"
  homepage "https://github.com/pirj/aq"
  url "https://github.com/pirj/aq.git", tag: "v2.5.7", revision: "3d83caadebba6932beb2f7a4bdb493236671e03c"
  license "MIT"
  head "https://github.com/pirj/aq.git", branch: "main"

  depends_on "coreutils" # shuf
  depends_on "gnupg"     # Alpine ISO signature verification
  depends_on "qemu"
  depends_on "socat"
  depends_on "tio"
  depends_on "wget"      # Alpine ISO download

  def install
    bin.install "aq"
    bash_completion.install "completions/aq.bash" => "aq"
  end

  def caveats
    if OS.mac?
      <<~EOS
        macOS Apple Silicon + live snapshots:
          QEMU 11.0.0 (currently the homebrew-core release) has an upstream
          aarch64-HVF regression that asserts on every incoming migration,
          so `aq new --from-snapshot=<live-tag>` will fail. Cold snapshots,
          fanout from cold tags, and everything else work fine. Linux KVM
          is unaffected.

          Workaround until QEMU 11.1.0 ships: PATH-prepend the previous
          keg if `brew upgrade` left it around (it usually does):
              ls /opt/homebrew/Cellar/qemu
              export PATH="/opt/homebrew/Cellar/qemu/10.0.3/bin:$PATH"
              qemu-system-aarch64 --version    # expect "version 10.0.3"

          See aq README Troubleshooting for the full root-cause writeup.
      EOS
    else
      <<~EOS
        On Linux, aq additionally needs:

          * KVM access (/dev/kvm readable + writable by your user):
              sudo usermod -aG kvm $USER   # log out and back in
              [ -r /dev/kvm ] && [ -w /dev/kvm ] && echo "KVM OK"

          * System OVMF firmware (not provided by brew on Linux). On Debian/Ubuntu:
              sudo apt-get install -y ovmf

          * netcat-openbsd for `nc -U` unix-socket support. Most distros ship it.
      EOS
    end
  end

  test do
    # `aq --version` calls detect_host first, which requires /dev/kvm on Linux —
    # not available in brew test sandboxes. Instead verify the script installed,
    # is executable, and parses cleanly under bash.
    assert_predicate bin/"aq", :executable?
    system "/bin/bash", "-n", bin/"aq"
  end
end
