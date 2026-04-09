class Tolmoenv < Formula
  desc "Version manager for the Tolmo CLI"
  homepage "https://github.com/tolmohq/tolmoenv"
  head "https://github.com/tolmohq/tolmoenv.git", branch: "main"

  def install
    prefix.install "bin", "lib", "libexec"
  end

  test do
    system bin/"tolmoenv", "version"
  end
end
