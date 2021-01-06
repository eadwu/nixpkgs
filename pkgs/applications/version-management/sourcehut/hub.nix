{ lib, fetchgit, buildPythonPackage
, srht }:

buildPythonPackage rec {
  pname = "hubsrht";
  version = "0.11.18";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    rev = version;
    sha256 = "j22C3VUEnIXKu/iqFTjQhMfv/UEB4lgmaLWUbgEVHqE=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hub.sr.ht";
    description = "Project hub service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
