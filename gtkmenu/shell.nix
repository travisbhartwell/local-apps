{
  nixpkgs ? import <nixpkgs> {}
, compiler ? "ghc801"
}:

let
  pkgs = nixpkgs.pkgs;
  ghc  = pkgs.haskell.packages.${compiler};
  f    = import ./gtkmenu.nix;
  drv  = ghc.callPackage f {};
in
  (pkgs.haskell.lib.addBuildTools drv [
   ghc.cabal-install
  ]).env
