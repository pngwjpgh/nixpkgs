{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, botocore
, click
, enum-compat
, hypothesis
, jmespath
, mock
, mypy-extensions
, pip
, pytest
, pyyaml
, setuptools
, six
, typing
, watchdog
, wheel
}:

buildPythonPackage rec {
  pname = "chalice";
  version = "1.21.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72efc25672ce7535c0e26bbe7157d7bd31ab12ed3f5221a64367548ca2daa265";
  };

  checkInputs = [ watchdog pytest hypothesis mock ];
  propagatedBuildInputs = [
    attrs
    botocore
    click
    enum-compat
    jmespath
    mypy-extensions
    pip
    pyyaml
    setuptools
    six
    wheel
  ] ++ lib.optionals (pythonOlder "3.5") [
    typing
  ];

  # conftest.py not included with pypi release
  doCheck = false;

  postPatch = ''
    sed -i setup.py -e "/pip>=/c\'pip',"
    substituteInPlace setup.py \
      --replace 'pip>=9,<=19.4' 'pip' \
      --replace 'typing==3.6.4' 'typing' \
      --replace 'attrs==17.4.0' 'attrs' \
      --replace 'click>=6.6,<7.0' 'click'
  '';

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Python Serverless Microframework for AWS";
    homepage = "https://github.com/aws/chalice";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
