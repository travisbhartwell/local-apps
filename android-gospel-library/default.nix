{ androidenv }:

androidenv.emulateApp {
  name = "gospel-library";
  app = ./org.lds.ldssa-1.apk;
  platformVersion = "21";
  useGoogleAPIs = false;
  enableGPU = true;
  abiVersion = "armeabi-v7a";

  package = "org.lds.ldssa";
  activity = "org.lds.ldssa.Main";

  avdHomeDir = "$HOME/.gospel-library";
}
