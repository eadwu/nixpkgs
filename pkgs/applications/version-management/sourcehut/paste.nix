{ lib, fetchgit, buildPythonPackage
, srht, pyyaml }:

buildPythonPackage rec {
  pname = "pastesrht";
  version = "0.12.0";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    rev = version;
    sha256 = "NUh3bB50R3OEcLT17Izw5W87D8HWymmLC79yS618FIc=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/paste.sr.ht";
    description = "Ad-hoc text file hosting service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
