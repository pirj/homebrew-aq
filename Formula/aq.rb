class Aq < Formula
  desc "QEMU wrapper to run Alpine Linux VMs on macOS and Linux"
  homepage "https://github.com/pirj/aq"
  url "https://github.com/pirj/aq.git", tag: "v2.5.4", revision: "7dd2515f4dcae89f96ec1fe776b78f4e33bac043"
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
    on_linux do
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
