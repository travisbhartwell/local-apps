{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc801", dmenu ? nixpkgs.pkgs.dmenu }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./gtkmenu.nix { inherit (nixpkgs.pkgs) dmenu; }
