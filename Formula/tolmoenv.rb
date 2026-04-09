class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  url "https://github.com/tolmohq/tolmoenv/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "9596bd1e0e7f14d85905ba00d9e6a4ed034e6e538e5779b37eb876579c0a8003"
  head "https://github.com/tolmohq/tolmoenv.git", branch: "main"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/tolmo"
    bin.install_symlink libexec/"bin/tolmoenv"
  end

  test do
    system bin/"tolmoenv", "version"
  end
end
