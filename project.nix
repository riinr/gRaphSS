{ pkgs, ... }:
let
  muslEnv  = pkgs.overrideCC pkgs.stdenv pkgs.pkgsMusl.gcc;
  libressl = pkgs.libressl.override { buildShared = false; stdenv = muslEnv; };
  sls-nim  = pkgs.callPackage ./sls-nim.nix {};
  sls      = pkgs.nodePackages.serverless;
in
{ 
  imports =  [
    ./gitignore.nix
    ./FeedMe/project.nix
  ];

  files.alias.deploy  = ''cd $PRJ_ROOT/FeedMe;sls deploy $@'';
  files.direnv.enable = true;

  env = [
    { name = "AWS_LAMBDA_FUNCTION_MEMORY_SIZE"; value = "-1024"; }
    { name = "AWS_LAMBDA_FUNCTION_NAME";        value = "gRaphSS"; }
    { name = "AWS_LAMBDA_FUNCTION_VERSION";     value = "1.1.0"; }
    { name = "AWS_LAMBDA_LOG_GROUP_NAME";       value = "asdfasdf"; }
    { name = "AWS_LAMBDA_LOG_STREAM_NAME";      value = "asdf"; }
    { name = "AWS_LAMBDA_RUNTIME_API";          value = "localhost"; }
    { name = "PKG_CONFIG_PATH";                  eval = "$DEVSHELL_DIR/lib/pkgconfig/"; }
  ];
  devshell.packages = [
    sls-nim
    pkgs.musl.dev
    libressl.dev
    "binutils"
    "gcc"
    "nim"
    "pkg-config"
    "upx" 
    "zip"
  ];

}
