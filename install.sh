#!/bin/bash

# インストール元ディレクトリ（このスクリプトが存在するディレクトリ）を取得
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# バックアップディレクトリの作成
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# メッセージ表示用の関数
function print_message {
    local message=$1
    echo "=============================="
    echo "$message"
    echo "=============================="
}

# Dotfileのバックアップ及びコピー関数
function backup_and_copy {
    local file=$1

    # ファイルが存在するかチェック
    if [ -e "$HOME/$file" ]; then
        # バックアップディレクトリへ移動
        mv "$HOME/$file" "$BACKUP_DIR/"
        echo "バックアップ: $file を $BACKUP_DIR に移動しました。"
    fi

    # ファイルをコピー
    cp -r "$SOURCE_DIR/$file" "$HOME/$file"
    echo "コピー: $file を $HOME にコピーしました。"
}

# インストール開始
print_message "インストール開始"

# インストール元ディレクトリから . で始まるファイルとディレクトリを検索
FILES_TO_COPY=$(find "$SOURCE_DIR" -maxdepth 1 -name ".*" -not -name "." -not -name ".." -not -name ".git")


# Dotfileのバックアップ及びコピーを実行
for file in $FILES_TO_COPY; do
    # ファイルパスからファイル名を抽出
    file_name=$(basename "$file")
    backup_and_copy "$file_name"
done

# インストール終了メッセージ
print_message "Git Username and Emailを設定してください（~/.gitconfig）"
print_message "インストール完了"
