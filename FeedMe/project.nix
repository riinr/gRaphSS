{
  files.json."/FeedMe/package.json" = {
    name =  "gRaphSS-FeedMe";
    version = "0.1.0";
    description = "Nim RSS crawler";
    devDependencies."@epiphone/serverless-nim" = "^0.0.2";
    devDependencies."serverless" = "^1.61.1";
  };
  files.yaml."/FeedMe/serverless.yaml" = {
    service = "gRaphSS-FeedMe";
    provider.name = "aws";
    provider.runtime = "nim";
    package.individually = true;
    package.excludeDevDependencies = false;
    plugins = [ "@epiphone/serverless-nim" ];
    functions.gRaphSS-FeedMe.handler = "src/handler.nim";
    functions.gRaphSS-FeedMe.events = [ { schedule.rate = "rate(2 hours)"; } ];
    custom.nim.flags = [
      "--opt:size"
      "--gc:orc"
      "-d:librssl"
      "-d:release"
      "-d:musl"
    ];
  };
}
