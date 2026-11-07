cask "kubenx" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.7"
  sha256 arm:   "31094b7b7006820ce721771449dc9374c19a8a3d40ec81b232e4116c85cd666b",
         intel: "139adaaa03441e87ac36783da972f5b0417071b3addecea6ad124a997fe2b2a5"

  url "https://dl.kubenx.app/v#{version}/kubenx-#{version}-macos-#{arch}.dmg"
  name "KubeNx"
  desc "Kubernetes workspace"
  homepage "https://kubenx.app/"

  livecheck do
    url "https://dl.kubenx.app/latest/manifest.json"
    strategy :json do |json|
      json["tag_name"]&.delete_prefix("v")
    end
  end

  depends_on :macos

  app "KubeNx.app"

  # The app is not notarized: sign it ad hoc on this Mac and drop quarantine so Gatekeeper lets it open.
  postflight_steps do
    run "/usr/bin/codesign", args: ["--force", "--deep", "--sign", "-", "{{appdir}}/KubeNx.app"]
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/KubeNx.app"]
  end

  zap trash: "~/Library/Application Support/kubenx"
end
