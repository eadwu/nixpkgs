{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "erlport";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "171rd8v0jbn847xgynas9cirkrff90q2i14ar95rc01aa3hr9n5v";
  };

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "Connect Erlang to other languages";
    homepage = "https://github.com/hdima/erlport";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
