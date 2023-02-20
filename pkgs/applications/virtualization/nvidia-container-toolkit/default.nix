{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, libnvidia-container
}:
buildGoModule rec {
  pname = "nvidia-container-toolkit";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qn1bmbf6SVFqb3hogVvWr8xMrDoh9St5/gQe0gfWHl4=";
  };

  vendorSha256 = null;
  ldflags = [ "-s" "-w" "-extldflags=-Wl,-z,lazy" ];
  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ libnvidia-container ];

  # https://github.com/NVIDIA/nvidia-docker/issues/1682#issuecomment-1250952249
  postInstall = ''
    ln -sf $out/bin/nvidia-container-runtime-hook $out/bin/nvidia-container-toolkit
  '';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/NVIDIA/nvidia-container-toolkit";
    description = "NVIDIA container runtime hook";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
