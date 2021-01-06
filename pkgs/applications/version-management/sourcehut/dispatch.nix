{ lib, fetchgit, buildPythonPackage
, srht, pyyaml, PyGithub }:

buildPythonPackage rec {
  pname = "dispatchsrht";
  version = "0.14.11";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/dispatch.sr.ht";
    rev = version;
    sha256 = "HJ7PJ+vl1XFCNqPrWFClll+bUijX8AwrqflWCG3iwEE=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pyyaml
    PyGithub
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://dispatch.sr.ht/~sircmpwn/dispatch.sr.ht";
    description = "Task dispatcher and service integration tool for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
