{ lib, fetchgit, buildPythonPackage
, buildGoModule
, pgpy, srht, redis, bcrypt, qrcode, stripe, zxcvbn, alembic, pystache
, sshpubkeys, weasyprint, dnspython }:

let
  version = "0.53.3";

  buildAPI = src: buildGoModule {
    inherit src version;
    pname = "metasrht-api";

    vendorSha256 = "11avngd311nr6432hb4db9y1kfppkqi220mgfdpmmkzn5pm59avp";
  };
in buildPythonPackage rec {
  pname = "metasrht";
  inherit version;

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    rev = version;
    sha256 = "CFoAbu8vvFyMXW4DuQMt58q0LKIS0pXnLVXNWN0jtoM=";
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    pgpy
    srht
    redis
    bcrypt
    qrcode
    stripe
    zxcvbn
    alembic
    pystache
    sshpubkeys
    weasyprint
    dnspython
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${buildAPI "${src}/api"}/bin/api $out/bin/metasrht-api
  '';

  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/meta.sr.ht";
    description = "Account management service for the sr.ht network";
    license = licenses.agpl3;
    maintainers = with maintainers; [ eadwu ];
  };
}
