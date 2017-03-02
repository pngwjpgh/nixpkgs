{ fetchFromGitHub
, python
, wrapPython
, stdenv
}:

stdenv.mkDerivation rec {
  name = "nitpick-${version}";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "travisb-ca";
    repo = "nitpick";
    rev = version;
    sha256 = "11gn6nc6ypwivy20bx1r0rm2giblwx6jv485zk875a9pdbcwbrf6";
  };

  buildInputs = [ python ];
  nativeBuildInputs = [ wrapPython ];

  installPhase = ''
    mkdir -p $out/share/src
    install -m 755 -t $out/share/src nitpick.py
  
    mkdir -p $out/bin
    ln -s $out/share/src/nitpick.py $out/bin/nitpick
  '';

  postFixup = ''
    buildPythonPath "$out"

    patchPythonScript "$out/share/src/nitpick.py"
  '';

  meta = {
    description = "A distributed issue tracker";
    longDescription = ''
      Nitpick is a distributed issue tracker. It helps keep track of which nits you
      should pick. It's intended to be used with source code such that the issues can
      follow the code via whatever VCS or distribution mechanism.
    '';
    homepage = http://travisbrown.ca/projects/nitpick/docs/nitpick.html;
    license = with stdenv.lib.licenses; gpl2;
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
