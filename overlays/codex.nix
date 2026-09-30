final: prev: let
  version = "0.153.4";

  sources = {
    x86_64-linux = {
      codex = {
        url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
        hash = "sha256-9HlCTsoJJITcQNh64oxE9MxAI0pgBF1hMeSTgA2BSjA=";
      };

      host = {
        url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-code-mode-host-x86_64-unknown-linux-musl.tar.gz";
        hash = "sha256-+VgwqGlZCVdmS7/Ge8ywh3OAa2k2cLrxWQgXb4m0zTE=";
      };
    };
  };

  source =
    sources.${prev.stdenv.hostPlatform.system}
        or (throw "Unsupported Codex platform: ${prev.stdenv.hostPlatform.system}");

  codexSrc = prev.fetchurl source.codex;
  hostSrc = prev.fetchurl source.host;
in {
  codex = prev.stdenvNoCC.mkDerivation {
    pname = "codex";
    inherit version;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"

      codex_bin="$(tar -tzf "${codexSrc}" | head -n1)"
      host_bin="$(tar -tzf "${hostSrc}" | head -n1)"

      tar -xOzf "${codexSrc}" "$codex_bin" > "$out/bin/codex"
      tar -xOzf "${hostSrc}" "$host_bin" > "$out/bin/codex-code-mode-host"

      chmod 0755 "$out/bin/codex" "$out/bin/codex-code-mode-host"
      runHook postInstall
    '';

    meta = {
      description = "OpenAI Codex CLI";
      homepage = "https://github.com/openai/codex";
      license = prev.lib.licenses.asl20;
      mainProgram = "codex";
    };
  };
}
