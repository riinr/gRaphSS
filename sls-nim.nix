{ nodePackages, fetchgit, runCommand }: 
let
  name = "serverless-nim";
  version = "0.0.2";
  src = fetchgit {
    url = "https://github.com/epiphone/serverless-nim";
    name = "serverless-nim-src";
    rev = "bb5d921a82f37932cab8398dbdcf070f887578f6";
    sha256 = "sha256-F0guqzMQ4474Iursf9YggK/SMjHBVfovOolN6SXhrNA=";
  };
in runCommand "serverless-nim" {} ''
  mkdir -p $out/lib
  mkdir -p $out/bin
  cp -R ${nodePackages.serverless}/lib/* $out/lib/
  ln -s $out/lib/node_modules/serverless/bin/serverless.js $out/bin/sls
  chmod +rw -R $out/
  chmod +x -R $out/lib/node_modules/serverless/bin
  mkdir -p $out/lib/node_modules/serverless/node_modules/@epiphone/serverless-nim
  cp -R ${src}/* $out/lib/node_modules/serverless/node_modules/@epiphone/serverless-nim/
''
