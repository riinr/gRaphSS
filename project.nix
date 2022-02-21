{ pkgs, extraModulesPath ? ./., ... }@args:
let
  musl-gcc-env = pkgs.callPackage ./FeedMe/musl-gcc.nix {};
  stdenv = musl-gcc-env.stdenv;
  ssl-lib = pkgs.callPackage ./FeedMe/libressl.nix { inherit stdenv; };
in
{ 
  imports =  [
    ./FeedMe/project.nix
    "${extraModulesPath}/language/c.nix"
  ];
  # enable .gitignore creation
  files.gitignore.enable = true;
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup" = true;
  files.gitignore.template."Global/Diff" = true;
  files.gitignore.pattern."*.yaml" = true;
  files.gitignore.pattern."*.json" = true;
  files.gitignore.pattern."nimbledeps" = true;
  # now we can use 'convco' command https://convco.github.io
  files.cmds.convco = true;
  # now we can use 'feat' command as alias to convco
  files.alias.feat = ''convco commit --feat $@'';
  files.alias.fix = ''convco commit --fix $@'';
  files.alias.chore = ''convco commit --chore $@'';

  files.cmds.nim-unwrapped = true;
  files.cmds.nimble-unwrapped = true;
  files.cmds.nodejs-14_x = true;
  files.cmds.upx = true;
  files.cmds.gnumake = true;
  files.cmds.zip = true;
  language.c.compiler = "musl";
  language.c.libraries = ["musl" "gcc-unwrapped" "binutils-unwrapped" ssl-lib];
  language.c.includes = ["musl" "gcc-unwrapped" "binutils-unwrapped" ssl-lib];
  env = [
    { name = "AWS_LAMBDA_FUNCTION_NAME"; value ="gRaphSS"; }
    { name = "AWS_LAMBDA_FUNCTION_VERSION"; value ="1.1.0"; }
    { name = "AWS_LAMBDA_FUNCTION_MEMORY_SIZE"; value ="-1024"; }
    { name = "AWS_LAMBDA_LOG_GROUP_NAME"; value ="asdfasdf"; }
    { name = "AWS_LAMBDA_LOG_STREAM_NAME"; value ="asdf"; }
    { name = "AWS_LAMBDA_RUNTIME_API"; value ="localhost"; }
  ];
}
