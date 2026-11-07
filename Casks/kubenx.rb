cask "kubenx" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.8"
  sha256 arm:   "751f151280dfb984d3e400483a14e4051435ca96bb77328f14b6469e4a00f3af",
         intel: "2a1dc6e747be7ef0a60fc006c993ef738b80088d160d9081f928b501ddf53b8d"

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
