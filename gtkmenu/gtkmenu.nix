{ mkDerivation, dmenu, base, glib, gtk, stdenv }:

mkDerivation {
  pname = "gtkmenu";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ base glib gtk ];
  description = "dmenu workalike using gtk";
  license = stdenv.lib.licenses.mit;

  # This feels like it should be:
  # inherit dmenu;
  # But this is what works:
  buildTools = [ dmenu ];
  # Technically I should probably not have copied this file
  # From the source of dmenu but patch it from the source, but
  # this seemed easier.
  postPatch = ''
    substituteInPlace ./gtkmenu_run --replace dmenu gtkmenu
    sed -ri -e 's!\<(gtkmenu)\>!'"$out/bin"'/&!g' gtkmenu_run
    sed -ri -e 's!\<(stest)\>!'"${dmenu}/bin"'/&!g' gtkmenu_run
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp gtkmenu_run $out/bin/gtkmenu_run
  '';
}
