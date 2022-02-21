{
  files.yaml."/FeedMe/serverless.yaml" = {
    service = "gRaphSS-FeedMe";
    provider.name = "aws";
    provider.runtime = "nim";
    package.individually = true;
    provider.lambdaHashingVersion = "20201221";
    package.excludeDevDependencies = false;
    plugins = [ "@epiphone/serverless-nim" ];
    functions.gRaphSS-FeedMe.handler = "src/handler.nim";
    functions.gRaphSS-FeedMe.events = [ { schedule.rate = "rate(2 hours)"; } ];
    custom.nim.flags = [
      "--gc:orc"
      "--opt:size"
      "-d:release"
      "-d:strip"
      "-d:nix"
    ];
  };
}
