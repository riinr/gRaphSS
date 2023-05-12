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
