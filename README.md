# FindOldMp3s

This project creates a CLI tool which will find MP3 files with bad bitrate. Bakeware will produce a standalone binary
file - this is NO escript release!

## Setup

```shell
mix deps.get
MIX_ENV=prod mix release
```

The built binary will be in `burrito_out/example_cli_app_linux`

## Usage

```shell
./burrito_out/example_cli_app_linux "~/**/*.{mp3}"
```

## Development

Clean cache:

```shell
yes | burrito_out/example_cli_app_linux maintenance uninstall
```
