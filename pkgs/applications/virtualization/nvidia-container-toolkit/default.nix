{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
}:
buildGoModule rec {
  pname = "nvidia-container-toolkit";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-b4mybNB5FqizFTraByHk5SCsNO66JaISj18nLgLN7IA=";
  };

  vendorSha256 = null;
  ldflags = [ "-s" "-w" ];
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mv $out/bin/{pkg,${pname}}
    ln -s $out/bin/nvidia-container-{toolkit,runtime-hook}
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
