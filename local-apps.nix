{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  emacs-server = pkgs.callPackage ./emacs-server { };
  gospel-libray-android = pkgs.callPackage ./gospel-libray-android { };
  gtkmenu = pkgs.haskellPackages.callPackage ./gtkmenu { inherit (pkgs) dmenu; };
  travis-hartwell-mail = pkgs.callPackage ./travis-hartwell-mail { };

  iamtravis = pkgs.callPackage ../blog/iamtravis { pygments = pkgs.python27Packages.pygments; };
}
