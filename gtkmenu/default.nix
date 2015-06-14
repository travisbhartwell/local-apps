{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7101", dmenu ? nixpkgs.pkgs.dmenu }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./gtkmenu.nix { inherit (nixpkgs.pkgs) dmenu; }
