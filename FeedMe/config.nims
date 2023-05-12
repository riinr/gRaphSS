when fileExists("./nix.config.nims"):
  import strutils
  include ./nix.config.nims
  when dirExists "./nimbledeps/pkgs":
    for pkg in listDirs "./nimbledeps/pkgs":
      switch "path", pkg

type 
  Params = object
    switches: seq[string]
    args: seq[string]


proc getArgs(taskName: string): ref Params =
  result = new Params
  var
    switches: seq[string]
    args: seq[string]
    numParams = paramCount()
    startAt: int = 0

  for i in 0 .. numParams:
    startAt = i + 1
    if paramStr(i) == taskName:
        break

  for i in startAt .. numParams:
    let arg = paramStr(i)
    if arg[0] == '-':
      switches.add(arg)
    else:
      args.add(arg)

  result.switches = switches
  result.args = args

task optimize, "Reduce binary size":
  let params = getArgs("optimize")
  for arg in params.args:
    if findExe("strip") != "":
      echo "Running 'strip -s' .."
      exec "strip -s " & arg
    if findExe("upx") != "":
      echo "Running 'upx' .."
      exec "upx " & arg

task zip, "Create a zip to AWS":
  let params = getArgs("zip")
  for arg in params.args:
    selfExec "optimize " & arg
    let tmpDir = gorge "mktemp -d"
    exec "cp "& arg & " " & tmpDir & "/bootstrap"
    exec "zip lambda.zip " & tmpDir

