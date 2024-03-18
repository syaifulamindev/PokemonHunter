# Installtions

## Mise (formerly called rtx)

This tools is required to install, manage, and activate versions of Tuist in your environment.


### Installation with homebrew
```sh
brew install mise
```

### Installation with CURL
```
curl https://mise.jdx.dev/install.sh | sh
```

### Check mise version
```
mise --version
```

## Tuist
Effortlessly build, test, and deploy your Xcode projects with Tuist's revolutionary automation and project management features.

Tuist is a command line tool that helps you generate, maintain and interact with Xcode projects. It's open source and written in Swift.

### Uninstall Tuist
Uninstall old version if you already install old tuist version, you can uninstall tuist (old version tuist not using `mise` tool)

```sh
tuist uninstall <version>
```

### Install Tuist
Install newewst version of tuist using `mise`
```sh
mise install tuist@4.1.0
```

### set tuist for local
```sh
mise local tuist 4.1.0
```

### set tuist global version
update tuist version with your installed version
```sh
mise use -g tuist@4.1.0
```