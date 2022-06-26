#!/bin/bash

# 使い方
# sshd が起動しているサーバーで使用する
# 複数の鍵を登録可能
# ./ssh-user-add.sh -u ユーザー名 -p 公開鍵のパス

user_name=""
pubkey_path=""

num=1
while [ "$1" != "" ] ; do
  if [ "$1" == "-h" ]; then
    echo "Usage: ./ssh-user-add.sh -u hoge -p ./id_rsa.pub"
    echo ""
    echo " -u user              : ssh user name"
    echo " -p public-key-path   : public-key path of ssh"
    echo " [-h help]            : show this help"
    echo ""
  elif [ "$1" == "-u" ]; then
    user_name=$2
  elif [ "$1" == "-p" ]; then
    pubkey_path=$2
  fi

  shift 1
  num=$(($num+1))
done

sudo useradd -m "$user_name"
sudo mkdir /home/"$user_name"/.ssh
sudo touch /home/"$user_name"/.ssh/authorized_keys
sudo cat  "$pubkey_path" | sudo tee -a /home/"$user_name"/.ssh/authorized_keys
sudo chown "$user_name" /home/"$user_name"/.ssh
sudo chown "$user_name" /home/"$user_name"/.ssh/authorized_keys
sudo chmod 700 /home/"$user_name"/.ssh
sudo chmod 600 /home/"$user_name"/.ssh/authorized_keys
sudo rm "$pubkey_path"
