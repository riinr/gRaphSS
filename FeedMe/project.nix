{
  files.yaml."/FeedMe/serverless.yaml" = {
    service = "gRaphSS-FeedMe";
    provider.name = "aws";
    provider.runtime = "nim";
    provider.memorySize = 128;
    provider.lambdaHashingVersion = "20201221";
    provider.httpApi.cors = true;
    package.individually = true;
    package.excludeDevDependencies = false;
    plugins = [ "@epiphone/serverless-nim" ];
    functions.gRaphSS-FeedMe.handler = "src/CROwN.nim";
    functions.gRaphSS-FeedMe.events = [ { schedule.rate = "rate(2 hours)"; } ];
    functions.gRaphSS-GraphQL.handler = "src/CRQwnS.nim";
    functions.gRaphSS-GraphQL.events = [ { 
      httpApi.method = "POST";
      httpApi.path = "/";
    } ];
    custom.nim.flags = [
      "--gc:arc"
      "-d:release"
      "-d:strip"
    ];
  };
  files.json."/FeedMe/events/invalidQuery.json" = {
    isBase64Encoded = false;
    body = ''hello world'';
  };
  files.json."/FeedMe/events/query.json" = {
    isBase64Encoded = false;
    body = ''
      {
        categories(filter: {
          eventId: "batata"
        }) {
          eventId
          items {
            uid
            parent
            title
          }
        }
      }
    '';
  };
  files.gitignore.pattern."nix.config.nims" = true;
  files.text."/FeedMe/nix.config.nims" = ''
    let
      muslGccPath    = findExe("musl-gcc")
      libreSSLCFlags = staticExec("pkg-config --static --cflags libssl")
      libreSSLLFlags = staticExec("pkg-config --static --libs   libssl")
    switch "define",         "ssl"
    switch "define",         "libressl"
    switch "define",         "release"
    switch "gcc.exe",        muslGccPath
    switch "gcc.linkerexe",  muslGccPath
    switch "passL",          "-static -s -Wl,-z,noseparate-code"
    switch "passC",          libreSSLCFlags
    switch "passL",          libreSSLLFlags
    switch "dynlibOverride", "libssl"
    switch "dynlibOverride", "libcrypto"
    switch "threads",        "on"
  '';
}
