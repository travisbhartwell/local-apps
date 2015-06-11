{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  travis-hartwell-mail = import ./travis-hartwell-mail {
    inherit (pkgs) stdenv makeDesktopItem chromiumBeta;
  };
}
