{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7103", dmenu ? nixpkgs.pkgs.dmenu }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./gtkmenu.nix { inherit (nixpkgs.pkgs) dmenu; }
