# flake8-annotations

Flake8-annotations is failing to build by default in this scenario.
It is the only dependency in the Poetry project, and [this error](./build-log-flake8-annotations.log)
is thrown when trying to perform a `nix run`.

The problem is that flake8-annotations has a transitive dependency
on poetry-core, which is not actually present in the [poetry.lock](./poetry.lock).
This is a problem with Poetry really, as it's not tracking build
dependencies correctly. As a result, when the package is built
within a Nix build sandbox (which has no internet connectivity and
odd write access to the source), it fails trying to get this package.

There's 3 solutions to this problem:

- Have upstream add poetry-core to their dev dependencies.
- Override the package in the [flake.nix](./flake.nix) via poetry2nix overrides.
- Update the overrides in [poetry2nix](https://github.com/nix-community/poetry2nix/blob/master/overrides/build-systems.json).

In this case, I took the second option, using [poetry2nix' overrides](https://github.com/nix-community/poetry2nix/blob/master/overrides/build-systems.json)
as an example.

However, this created a [new error](./override-build-log-flake8-annotations.log)..
