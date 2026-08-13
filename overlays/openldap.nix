final: prev: {
  openldap =
    if prev.stdenv.hostPlatform.system == "i686-linux"
    then
      prev.openldap.overrideAttrs (old: {
        doCheck = false;
      })
    else prev.openldap;
}
