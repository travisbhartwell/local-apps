{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
in
rec {
  travis-hartwell-mail = pkgs.callPackage ./travis-hartwell-mail { };
  emacs-server = pkgs.callPackage ./emacs-server { };
  gtkmenu = pkgs.haskellPackages.callPackage ./gtkmenu { inherit (pkgs) dmenu; };
  iamtravis = pkgs.callPackage ../blog/iamtravis { pygments = pkgs.python27Packages.pygments; };
}
