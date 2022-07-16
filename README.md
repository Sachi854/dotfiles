# Dotfiles
My Dotfiles. Fedora only.

# Table of Contents
- [Dotfiles](#dotfiles)
- [Table of Contents](#table-of-contents)
- [QuickStart](#quickstart)
- [install.sh](#installsh)
- [Environment](#environment)
  - [SSH-Key](#ssh-key)
  - [Vivaldi](#vivaldi)
  - [JetBrains Toolbox ans InteIIj IDEA](#jetbrains-toolbox-ans-inteiij-idea)
  - [VSCode](#vscode)
  - [Xremap](#xremap)
  - [Systemd](#systemd)
- [Tips](#tips)
  - [ssh-keygen](#ssh-keygen)
  - [SSH](#ssh)
  - [SSHD](#sshd)
  - [scp](#scp)
  - [ssh-copy-id](#ssh-copy-id)
  - [add ssh user ssh server](#add-ssh-user-ssh-server)
  - [FW (ssh-server)](#fw-ssh-server)
  - [Set proxy](#set-proxy)
    - [Terminal](#terminal)
    - [git](#git)
    - [DNF](#dnf)
    - [apt](#apt)
    - [pip](#pip)
  - [Laptop power optimize](#laptop-power-optimize)
  - [Disable C6 States of Zen env](#disable-c6-states-of-zen-env)
  - [Change dir lang](#change-dir-lang)
  - [Change audio  sample-format and rate](#change-audio--sample-format-and-rate)
  - [Disable mouse acceleration](#disable-mouse-acceleration)
  - [Change setting of GRUB2](#change-setting-of-grub2)
- [Links](#links)

# QuickStart
```bash
# sudo rpm --rebuilddb
sudo dnf upgrade -y
git clone https://github.com/Sachi854/dotfiles.git
#git clone git@github.com:Sachi854/dotfiles.git
cd dotfiles
chmod +x ./install.sh
./install.sh --all
```

# install.sh
```bash
install.sh --all
# Install Dotfiles etc. Can also be used for updates.
install.sh --dot
# Install dependent package.
install.sh --package
```

# Environment
## SSH-Key
```bash
ssh-keygen -t ed25519 -C "email@com"
cat ~/.ssh/id_ed25519.pub 
```

## Vivaldi
Download [here](https://vivaldi.com) and install.

```bash
sudo dnf install vivaldi-xx.x86_64.rpm
```

## JetBrains Toolbox ans InteIIj IDEA
Download [here](https://www.jetbrains.com/toolbox-app/) and install.

```bash
cd DOWNLOAD_DIR
tar fvx jetbrains-toolbox-xx.tar.gz
./jetbrains-toolbox-xx/jetbrains-toolbox
```

Install IDEA.

```bash
toolbox -> Tools -> IDEA -> Install
```

Add PATH of IDEA.

```bash
toolbox -> Tools -> IDEA -> Settings -> Configuration -> Geterate shell scripts => Enable
Shell scripts location => $HOME/bin
```

## VSCode
Add key and repository, If you run install.sh, you don't need it.

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
```

And install

```
dnf check-update
sudo dnf install code
```

## Xremap
- Env
  - https://github.com/k0kubun/xremap
- Keysetting
  - https://github.com/emberian/evdev/blob/1d020f11b283b0648427a2844b6b980f1a268221/src/scancodes.rs#L26-L572
  - xmodmap -pke

```bash
# Env file.
~/.xremap
# If edit ~/.xremap, run it.
systemctl --user restart xremap
```

## Systemd
```bash
# If change service file, run it.
systemctl --user daemon-reload

# Start and Enable service
systemctl --user start SERVICE
systemctl --user enable SERVICE

# If change .xremap, run it.
systemctl --user restart SERVICE
```

# Tips
## ssh-keygen
```shell
# key generate
ssh-keygen -t ed25519 -C {comment}
# change password
ssh-keygen -f {private-key-path} -p
```

## SSH
```shell
# basic usage
ssh -i {pub-key-path} -l {user} -p {port} {host-ip}
# multi-stage ssh
ssh -i {pub-key-path} -o ProxyCommand="ssh -W %h:%p -i {pub-key-path} -l {user} -p {port1} {host1-ip}" -l {user} -p {port2} {host2-ip}
# ssh over https
# 1. open port 443 of sshd
# 2. install corkscrew
ssh -i {pub-key-path} -o ProxyCommand="corkscrew {proxy-ip} {proxy-port} [authfile] %h %p" -l {user} -p 443 {host2-ip}
vim [authfile]
{user}:{passwd}
# only ssh local port forwarding
ssh -i {pub-key-path} -N -b {host1-nic-ip or 127.0.0.1} -L {port1}:{host2}:{port2} -l {user} -p {port} {host-ip}
# only ssh remote port forwarding
ssh -i {pub-key-path} -N -b {host1-nic-ip or 127.0.0.1} -R {port1}:{host2}:{port2} -l {user} -p {port} {host-ip}
# SSH dynamic port forwarding
# connect to socks://127.0.0.1:{port}
# can com via ssh server
ssh -i {pub-key-path} -D {port} -l {user} -p {port} {host-ip}
```

Make alias

```shell
vim ~/.ssh/config
```

```shell
Host alias1
        HostName {host1-ip}
        Port {port} 
        User {user}
        IdentityFile {private-key-path}
        ForwardX11 no
        TCPKeepAlive {yes}
        ServerAliveInterval {120}
Host mss
        HostName {host2-ip}
        Port {port} 
        User {user}
        IdentityFile {private-key-path}
        # %h is {host2-ip}, %p is {port}
        ProxyCommand ssh -W %h:%p alias1
Host soh
        HostName {host1-ip}
        Port 443 
        User {user}
        IdentityFile {private-key-path}
        ProxyCommand "corkscrew {proxy-ip} {proxy-port} [authfile] %h %p"
Host lf
        HostName {host-ip}
        Port {port} 
        User {user}
        IdentityFile {private-key-path}
        BindAddress {host1-nic-ip or 127.0.0.1}
        LocalForward port1 host2:port2
Host rf
        HostName {host-ip}
        Port {port} 
        User {user}
        IdentityFile {private-key-path}
        BindAddress {host1-nic-ip or 127.0.0.1}
        RemoteForward {port1} {host2:port2}
Host df
        HostName {host-ip}
        Port {port} 
        User {user}
        IdentityFile {private-key-path}
        DynamicForward {port}
```

```shell
ssh alias1
ssh mss
ssh lf
ssh rf
ssh df
```

## SSHD
```shell
vim sudo vim /etc/ssh/sshd_config

# change port
# Port 22
Port 20022
# add port
Port 20022
Port 30022
...

# disable password
PasswordAuthentication no

# deny user of empty password
PermitEmptyPasswords no

# :wq

# reboot sshd
sudo systemctl restart sshd.service
```

## scp
File transfer.

```shell
scp -i {~/.ssh/id_gcp.pub} {localfile} -P {port} {user}{@34.82.195.120}:{dir}
```

## ssh-copy-id
```shell
# Send pub key to remote host
ssh-copy-id -i {public-key-path} -P {port} {user}@{host-ip}:{dir}
```

## add ssh user ssh server
```shell
ssh sshd-server
curl -o ssh-user-add.sh https://raw.githubusercontent.com/Sachi854/dotfiles/master/scripts/ssh-user-add.sh
chmod +x ./ssh-user-add.sh
./ssh-user-add.sh -u {username} -p {public-key-path}
```

## FW (ssh-server)
```shell
sudo ufw default DENY
sudo ufw limit {ssh-port}/tcp
sudo ufw enable
```

## Set proxy
Note escape characters.

### Terminal
```bash
export http_proxy="http://username:password@foobar.com:8080"
export https_proxy="http://username:password@foobar.com:8080"
```

### git
```bash
git config --global http.proxy http://username:password@foobar.com:8080
git config --global https.proxy http://username:password@foobar.com:8080
```  

### DNF
```bash
vim /etc/dnf/dnf.conf
proxy=http://proxy.tylersguides.com:3128
proxy_username=dnf
proxy_password=password
```

### apt
```bash
sudo vim /etc/apt/apt.conf

Acquire::http::Proxy "http://username:password@foobar.com:8080"
Acquire::https::Proxy "http://username:password@foobar.com:8080"
```  

### pip
```bash
pip3 --proxy=http://username:password@foobar.com:8080 install numpy
```

## Laptop power optimize
```bash
$ sudo dnf install tlp
$ sudo tlp start
```

## Disable C6 States of Zen env
Load msr modules when loading OS

```
sudo vim /etc/modules-load.d/modules.conf 
```

```
msr
```

Auto disable c6 states at boot time

```
git clone https://github.com/joakimkistowski/amd-disable-c6.git
cd amd-disable-c6/
sudo make install
sudo systemctl enable amd-disable-c6.service
sudo systemctl start amd-disable-c6.service
reboot
```

If you want to be disable c6 at one time...

```
git clone https://github.com/r4m0n/ZenStates-Linux.git
cd ZenStates-Linux/
# disable c6
sudo python zenstates.py --c6-disable
# check state
sudo python zenstates.py -l
```

## Change dir lang
```bash
LANG=C xdg-user-dirs-gtk-update
```

## Change audio  sample-format and rate
```
sudo vim /etc/pulse/daemon.conf
```

```
;; default-sample-format = s16le
;; default-sample-rate = 44100
default-sample-format = s24le
default-sample-rate = 96000
```

```
pulseaudio -k
```

## Disable mouse acceleration
```
sudo dnf install gnome-tweaks
dgnome-tweaks
Keyboard & Mouse -> Mouse -> Acceleration Profile -> Flat
```

## Change setting of GRUB2
```
sudo vim /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
```

# Links
- [ようこそdotfilesの世界へ](https://qiita.com/yutkat/items/c6c7584d9795799ee164)
- [yutkat/dotfiles](https://github.com/yutkat/dotfiles)
- [install-gnome-extensions](https://github.com/cyfrost/install-gnome-extensions)
- [systemd.unit.html](https://www.freedesktop.org/software/systemd/man/systemd.unit.html)
