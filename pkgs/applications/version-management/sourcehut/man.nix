{ lib, fetchgit, buildPythonPackage
, srht, pygit2 }:

buildPythonPackage rec {
  pname = "mansrht";
  version = "0.15.6";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    rev = version;
    sha256 = "FnKZASI+1AC+EsbhQQe4b2F3DduTxu2PKhfcI60bCn0=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/man.sr.ht";
    description = "Wiki service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
