{ stdenv, emacs, gawk, systemd }:

stdenv.mkDerivation rec {
  name = "emacs-server-0.1";

  phases = [  "installPhase" "fixupPhase" ];

  inherit emacs gawk systemd;

  installPhase = ''
    mkdir -p "$out/share/emacs-server"
    cp -v ${./common-lib} "$out/share/emacs-server/common-lib"
    mkdir -p "$out/libexec/emacs-server"
    cp -v ${./connect-emacs} "$out/libexec/emacs-server/connect-emacs"
    cp -v ${./emacs-command} "$out/libexec/emacs-server/emacs-command"
    cp -v ${./preload-emacs} "$out/libexec/emacs-server/preload-emacs"
    cp -v ${./start-emacs} "$out/libexec/emacs-server/start-emacs"
    mkdir -p "$out/bin"
    cp -v ${./emacs} "$out/bin/emacs"

    substituteAllInPlace "$out/share/emacs-server/common-lib"
    substituteAllInPlace "$out/libexec/emacs-server/connect-emacs"
    substituteAllInPlace "$out/libexec/emacs-server/emacs-command"
    substituteAllInPlace "$out/libexec/emacs-server/preload-emacs"
    substituteAllInPlace "$out/libexec/emacs-server/start-emacs"
    substituteAllInPlace "$out/bin/emacs"
  '';

  meta = {
    description = "Wrapper around Emacs to autoload Emacs server";
  };
}
