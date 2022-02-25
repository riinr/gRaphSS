let 
  defaultVersion = "3.2.0";
  versions = {
    "3.1.2" = "sha256-+IovfqYXFJo05AwCLZkSlj8A6qYQmvQhMXUl5sl42JI="; # works
    "3.1.3" = "sha256-x2sDFqz2Euy2L1ywFKINlypmO9nkCr+VKobzuZi2n6A="; # works
    "3.1.4" = "sha256-QUwUnJljmD+AWggdtb067BRrX4LVKbtjh1rJQbJdy7Y="; # works
    "3.1.5" = "sha256-LBPdzsUIHA57p/k9g3CpGREXMJDxkiAH4dkN4nRQBJQ="; # works
    "3.2.0" = "sha256-R70utLRQPkfALvp+Z9L82Vx+rGvJ0Gs0OhtHBXk+0dU="; # works
    # I'm not sure why those other version didn't work
    "3.2.1" = "sha256-0o2yJM+20YAJsqfoyyE81clDu+yHVQBi/vajhHklAxU="; # not work
    "3.2.2" = "sha256-qdHh0DC4vMZ79kKLjA//FKVgLiI2JXuePXesrxLip6E="; # not work
    "3.2.3" = "sha256-QS3Cuqc5Iox3eek+sHzWRdXJZNLy2Dep/VbbdJhGPXM="; # not work
    "3.2.4" = "sha256-rB27ngWmSRCFZZmxrGERj97Bs9DHAOQkRNgcDV9Qelo="; # not work
    "3.2.5" = "sha256-eYpl/WHTheCdVZgQzfpGUS+N71kZJkz+8kGnsIbOfP4="; # not work
    "3.2.6" = "sha256-sENkBSDS7sVr0WrmOc5TAX7srMPYY4i1T4OKVI3jMls="; # not work
    "3.2.7" = "sha256-fDL/A3WXzkccfP2dy4RxzaOgKYOuujMVBZNizrOTS4Q="; # not work
    "3.3.0" = "sha256-cope3GPMtBjpFmvtEdS0PpYp/xxNQqObZJNHogQW+tY="; # not work
    "3.3.1" = "sha256-ptMxhl4BZKE6yFoijlJRf3z4+EiPL5XzTnhXMC+Xz9s="; # not work
    "3.3.2" = "sha256-hDQKxXDz7o6RBp3DoKzXpvbur8BZTZXzrhA0xdvCFlQ="; # not work
    "3.3.3" = "sha256-pHFWWzbM0acNC9fTfG6VxDompigptIfZ0s3r/li+MGY="; # not work
    "3.3.4" = "sha256-vM52ej/tJSv9EhD4p+NQWitU0wCPZuQ9m5Xj8wwHKTE="; # not work
    "3.3.5" = "sha256-ClE5Pw3xzyfgcAVKJ4ik0HMznzY9ec1ZQHahtMSL6aU="; # not work
    "3.4.0" = "sha256-5S6udY1AIGpx12OhqHtxA3IjvxmGrCOaa+Gm0qw5FtI="; # not work
    "3.4.1" = "sha256-EHzq5sqADoHLVjWEwWr6NtbHE4+t6UorPp2mVFb3xhw="; # not work
    "3.4.2" = "sha256-y4LKfVRzNpFzUvvSPbL8SDxsRNNRV7MngCFOx0GXs84="; # not work
  };
  src =  fetch: version: sha256: fetch {
    inherit sha256;
    url = "mirror://openbsd/LibreSSL/libressl-${version}.tar.gz";
  };
in
{ stdenv
, cmake
, fetchurl
, lib
, buildShared ? false
, patches ? []
, libresslVersion ? defaultVersion
, libresslSha256  ? versions."${defaultVersion}"
}: stdenv.mkDerivation {
  inherit patches;
  doCheck = false;
  nativeBuildInputs = [ cmake ];
  outputs = [ "dev" "out"];
  pname = "libressl";
  src = src fetchurl libresslVersion libresslSha256;
  version = libresslVersion;
  meta = with lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "https://www.libressl.org";
    license = with licenses; [ publicDomain bsdOriginal bsd0 bsd3 gpl3 isc openssl ];
    platforms   = platforms.all;
  };
}
