{ stdenv, appimageTools, autoPatchelfHook, desktop-file-utils
  , fetchurl, runtimeShell }:

let
  version = "3.5.11";
  pname = "standardnotes";
  name = "${pname}-${version}";

  plat = {
    i386-linux = "-i386";
    x86_64-linux = "x86_64";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    i386-linux = "009fnnd7ysxkyykkbmhvr0vn13b21j1j5mzwdvqdkhm9v3c9rbgj";
    x86_64-linux = "1fij00d03ky57jlnhf9n2iqvfa4dgmkgawrxd773gg03hdsk7xcf";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/standardnotes/desktop/releases/download/v${version}/standard-notes-${version}-linux-${plat}.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  nativeBuildInputs = [ autoPatchelfHook desktop-file-utils ];

in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    # directory in /nix/store so readonly
    cp -r  ${appimageContents}/* $out
    cd $out
    chmod -R +w $out
    mv $out/bin/${name} $out/bin/${pname}

    # fixup and install desktop file
    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value ${pname} standard-notes.desktop

    rm usr/lib/* AppRun standard-notes.desktop .so*
  '';

  meta = with stdenv.lib; {
    description = "A simple and private notes app";
    longDescription = ''
      Standard Notes is a private notes app that features unmatched simplicity,
      end-to-end encryption, powerful extensions, and open-source applications.
    '';
    homepage = "https://standardnotes.org";
    license = licenses.agpl3;
    maintainers = with maintainers; [ mgregoire ];
    platforms = [ "i386-linux" "x86_64-linux" ];
  };
}
