# Poetry2nix environment with Poetry

If you build a development environment with `poetry2nix.mkPoetryEnv`,
the resulting environment will not come with Poetry in its path.
This is a bit problematic when you are using Poetry in your workflow,
and rely on `nix develop` or `nix-shell` to set up your shell and PATH.

You cannot just add `pkgs.poetry` to the `extraPackages`, as it results
in [this error](./build-log-python-env.log).

```nix
{
    devShell = (pkgs.poetry2nix.mkPoetryEnv {
        projectDir = ./.;
        extraPackages = ps: [ ps.poetry ];
    }).env;
}
```

Instead, the solution is to `overrideAttrs` on the resulting environment
and adding Poetry to the nativeBuildInputs.

```nix
{
    devShell = (pkgs.poetry2nix.mkPoetryEnv {
        projectDir = ./.;
    }).env.overrideAttrs(final: prev: { nativeBuildInputs = [pkgs.poetry]; });
}
```
