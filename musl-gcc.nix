{ stdenv
, overrideCC
, wrapCCWith
, wrapBintoolsWith
, binutils-unwrapped
, musl
, gcc-unwrapped
}:
let
  cc = gcc-unwrapped;
  libc = musl;
  bintools = wrapBintoolsWith {
    inherit libc;
    bintools = binutils-unwrapped;
  };
  musl-gcc = wrapCCWith {
    inherit bintools libc cc;
  };
in {
  inherit bintools;
  cc = musl-gcc;
  stdenv = (overrideCC stdenv musl-gcc).override (prev: {
    extraBuildInputs = (prev.extraBuildInputs or []) ++ [
      libc.dev
    ];
  });
}
