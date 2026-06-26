class Mint < Formula
  desc "MINT — The Unified OSINT & Media Command Center"
  homepage "https://github.com/sayfalse/mint"
  url "https://github.com/sayfalse/mint/archive/refs/heads/main.tar.gz"
  version "1.0.8"

  depends_on "python"

  def install
    # Install the core scripts
    libexec.install "mint.py"
    
    # Vendor Python dependencies (colorama) directly into libexec/vendor to keep them isolated
    system "python3", "-m", "pip", "install", "--target", libexec/"vendor", "colorama"
    
    # Create the executable wrapper script
    (bin/"mint").write <<~EOS
      #!/bin/bash
      export PYTHONPATH="#{libexec}/vendor:#{libexec}:$PYTHONPATH"
      exec python3 "#{libexec}/mint.py" "$@"
    EOS
  end

  test do
    # Simple check to verify the help flag runs
    assert_match "MINT", shell_output("#{bin}/mint --help", 2)
  end
end
