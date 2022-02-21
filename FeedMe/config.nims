when defined(nix):
  let
    DEVSHELL_DIR = getEnv "DEVSHELL_DIR"
    muslGccPath = findExe("musl-gcc")
  switch "define", "ssl"
  switch "define", "libressl"
  switch "gcc.exe", muslGccPath
  switch "gcc.linkerexe", muslGccPath
  switch "passL", "-static"
  switch "passC", "-I" & DEVSHELL_DIR & "/include/openssl"
  switch "passL", "-L" & DEVSHELL_DIR & "/lib"
  switch "passL", "-lssl"
  switch "passL", "-lcrypto"
  switch "dynlibOverride", "libssl"
  switch "dynlibOverride", "libcrypto"


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
      exec "upx" & arg

task zip, "Create a zip to AWS":
  let params = getArgs("zip")
  for arg in params.args:
    selfExec "optimize " & arg
    
    let tmpDir = gorge "mktemp -d"
    exec "cp "& arg & " " & tmpDir & "/bootstrap"
    exec "zip lambda.zip " & tmpDir

