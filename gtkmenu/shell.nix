with (import <nixpkgs> {}).pkgs;
let pkg = haskellngPackages.callPackage
            ({ mkDerivation, base, glib, gtk, stdenv }:
             mkDerivation {
               pname = "gtkmenu";
               version = "0.1.0.0";
               src = ./.;
               isLibrary = false;
               isExecutable = true;
               buildDepends = [ base glib gtk ];
               extraLibraries = [ gtk ];
               description = "dmenu workalike using gtk";
               license = stdenv.lib.licenses.mit;
             }) {};
in
  pkg.env
