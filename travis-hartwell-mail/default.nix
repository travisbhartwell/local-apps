{ stdenv, makeDesktopItem, chromiumBeta
}:

stdenv.mkDerivation rec {
  name = "travis-hartwell-mail-0.1";

  phases = [ "installPhase" ];

  buildInputs = [ chromiumBeta ];

  desktopItem = makeDesktopItem {
    name = "TravisHartwellMail";
    desktopName = "Travis Hartwell Mail";
    genericName = "Mail";
    exec = "${chromiumBeta}/bin/chromium --app=http://mail.google.com/mail/u/0";
    icon = "TravisHartwellMail";
    comment = "GMail in its own app window";
    categories = "Application;Network;Email";
  };

  installPhase = ''
    mkdir -p "$out/share/applications"
    cp -v "${desktopItem}/share/applications/"* "$out/share/applications"
    chmod +w "$out/share/applications/TravisHartwellMail.desktop"
    echo "StartupWMClass=mail.google.com__mail_u_0" >> "$out/share/applications/TravisHartwellMail.desktop"
    chmod -w "$out/share/applications/TravisHartwellMail.desktop"

    mkdir -p "$out/share/icons/hicolor/128x128/apps/"
    cp -v ${./TravisHartwellMail.png} "$out/share/icons/hicolor/128x128/apps/TravisHartwellMail.png"
  '';

  meta = {
    description = "Application window for Travis Hartwell Mail";
    homepage = http://mail.travishartwell.net;
  };
}
