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
