# Blocksense Dev Shells

Blocksense Dev Shells is a collection of ready-to-use **development shell
environments** powered by Nix. It helps you quickly set up a consistent
development environment for projects that use **Rust** and **Node.js**
(JavaScript/TypeScript) – all with a single command. This means you spend less
time installing compilers and libraries and more time coding, with the added
benefit that everyone on your team gets the **same environment** (no more
"works on my machine" issues).

## Quick Reference

- **Default dev shell:** `nix develop github:blocksense-network/dev-shells`
  (Rust + Node.js combined)
- **Rust dev shell:** `nix develop github:blocksense-network/dev-shells#rust`
- **Node.js dev shell:** `nix develop github:blocksense-network/dev-shells#nodejs`

## Features

- **One-Command Setup:** Launch a fully equipped dev environment in one step,
  without manually installing multiple tools.
- **Rust and Node.js Support:** Includes the latest Rust toolchain (with Cargo)
  and Node.js (with npm and Yarn) out of the box. Use both together or each
  separately.
- **Reproducible & Consistent:** Uses Nix to ensure the environment is
  identical across different machines.
- **Cross-Platform:** Works on Linux and macOS (Intel or Apple Silicon). *(Nix
  can also be used on Windows via WSL2 if needed.)*
- **Common Dev Tools Included:** Besides Rust and Node, the shells come with
  common build tools and libraries (like `pkg-config`, OpenSSL, zlib, libusb,
  etc.) so that compiling projects just works. Python 3 is also included in the
  Node.js environment to support building native Node addons.

## Getting Started

1. **Install Nix (the package manager)** – If you don’t have Nix installed, we
   recommend using the **Determinate Nix Installer** for a quick and reliable
   setup. You can find it here: **[Determinate Nix Installer](https://zero-to-nix.com/start/install/)**.
   This installer works on Linux and macOS, and enables Nix’s flake feature by
   default (which is needed for using dev shells).
2. **Launch a dev shell** – Open a terminal in your project directory (or
   wherever you want to work) and run **one** of the following commands:
   - **Combined Rust + Node.js shell (default):**
     Includes Rust (compiler, Cargo) *plus* Node.js (npm) with Yarn and
     Python3. Use this if your project involves both Rust and Node (for example,
     a Rust backend and a Node.js frontend or tooling).
     ```bash
     nix develop github:blocksense-network/dev-shells
     ```
   - **Rust-only shell:**
     Includes Rust (the latest stable compiler and Cargo) and common C
     libraries for building Rust projects (openssl, libssl, zstd, etc.). Use this
     for pure Rust projects.
     ```bash
     nix develop github:blocksense-network/dev-shells#rust
     ```
   - **Node.js-only shell:**
     Includes Node.js (JavaScript runtime), npm, Yarn (modern Yarn v3 berry),
     and Python3 (often needed for building native Node modules). Use this for
     Node.js projects (including those using TypeScript or bundlers).
     ```bash
     nix develop github:blocksense-network/dev-shells#nodejs
     ```
3. **You're ready to code!** – After running the above command, your shell
   prompt will change (indicating you are now “inside” the Nix development
  shell). In this environment, you can run commands like `cargo build` for Rust
  or `yarn install` / `npm run` for Node projects, and all the necessary tools
  and libraries are already available. Feel free to edit code, compile, and run
  tests as you normally would. When you’re done, just type `exit` to leave the
  dev shell.

## Applying to Your Own Projects

- **No clone needed:** You don’t have to add anything to your project
  repository to use these dev shells. Simply run the `nix develop ...` command
  (as shown above) while in your project directory, and Nix will fetch the
  dev-shells environment from GitHub on the fly.
- **Using in a Flake project:** If your project is itself a Nix flake, you can
  use this repo as a flake input to provide a devShell. (This is an advanced
  use-case – beginners can skip this.) For example, you could reference
  `github:blocksense-network/dev-shells` in your `flake.nix` and use
  `devShells.default` or others in your outputs.
- **Customizing:** The provided shells cover common needs for Rust and Node.js.
  If you need additional tools or different versions, you can copy the approach
  from this repository’s **flake.nix** into your own project and adjust the list
  of packages. Essentially, Blocksense Dev Shells can serve as a template – a
  starting point for creating your own personalized dev shell.

- **Direnv Integration:** To automatically load a development shell in another
  repository using [direnv](https://direnv.net/), add a file named `.envrc` to
  your project with the following content:
  ```bash
  # shellcheck shell=bash

  if ! has nix_direnv_version || ! nix_direnv_version 3.0.4; then
    source_url "https://raw.githubusercontent.com/nix-community/nix-direnv/3.0.4/direnvrc" "sha256-DzlYZ33mWF/Gs8DDeyjr8mnVmQGx7ASYqA5WlxwvBG4="
  fi

  dotenv_if_exists

  use flake github:blocksense-network/dev-shells
  ```

  This snippet ensures that whenever you enter your project directory, direnv loads the Blocksense Dev Shell automatically.

With Blocksense Dev Shells, setting up a development environment is as simple
as copy-pasting a command. This allows you to **onboard new developers
quickly** and ensures that every build runs in a predictable environment. Enjoy
coding without worrying about installing dependencies!
