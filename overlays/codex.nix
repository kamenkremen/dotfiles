_final: prev: let
  version = "0.167.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-x86_64-unknown-linux-musl.tar.zst";
      hash = "sha256-n2e4hoixQ1kH4hSIWI/yAR/f8n5YLS05XohVv1Z6jP8=";
    };
  };

  source =
    sources.${prev.stdenv.hostPlatform.system}
        or (throw "Unsupported Codex platform: ${prev.stdenv.hostPlatform.system}");
in {
  codex = prev.stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit version;
    src = prev.fetchurl source;
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs = [prev.autoPatchelfHook prev.zstd];
    # The CLI and its executors use musl; the bundled voice helper uses glibc.
    buildInputs = [(prev.lib.getLib prev.stdenv.cc.libc)];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      # Preserve the package layout so Codex can discover every helper and resource.
      tar --zstd -xf "$src" -C "$out"
      chmod -R u+w "$out"
      runHook postInstall
    '';

    preFixup = ''
      addAutoPatchelfSearchPath "$out/codex-resources/voice/lib"
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [prev.versionCheckHook];

    meta = {
      description = "OpenAI Codex CLI";
      homepage = "https://github.com/openai/codex";
      license = prev.lib.licenses.asl20;
      mainProgram = "codex";
      platforms = builtins.attrNames sources;
    };
  };
}
