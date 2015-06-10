let
  pkgs = (import <nixpkgs> {});
  hs = pkgs.haskellngPackages;
  gtkmenu = hs.callPackage (import ./.) { };
in
  gtkmenu.env
