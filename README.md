# WebDAV server setup for macOS

A very simple setup based on nginx + WebDAV module with basic auth.
A typical usage: for use with Infuse (on tvOS or iOS), specially dedicated to UHD streaming (successfully
tested with rates > 300 Mbps).
Setup nginx as macOS service

## Usage

### Install

Just run:
```
./install.sh <WebDAV Share Folder> <WebDAV Password>
```
For example if you want to share a movies folder:
```
./install.sh /Users/user/Movies passw0rd`
```
In such case, your WebDAV will be available on http://<Server IP>/ (user: `webdav`, password: `passw0rd`)

### Optionally: build

- Edit `build.sh` and replace `NGINX_VERSION` with the disired nginx version.
- Run `./build.sh`
- Then perform the *install* phase
