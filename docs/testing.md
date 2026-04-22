# Testing Guide

このプロジェクトには、Linux環境（Ubuntu）でdotfilesが正しく動作することを確認するためのDockerベースのテスト環境が含まれています。

## 概要

Dockerイメージのビルド時に以下を実行します：
- GitHubリポジトリ（https://github.com/remma-takeuchi/dotfiles.git）から`chezmoi init --apply`を実行
- dotfilesの適用を完了

テスト環境では以下を確認します：
- chezmoiが正しく初期化されているか
- dotfilesが適用されているか
- スクリプトの構文が正しいか
- chezmoiの状態が正常か

## 必要要件

- Docker（Docker Desktopまたはdockerエンジン）
- make（オプション、簡単なコマンド実行のため）

## 使い方

### 1. Makefileを使用する方法（推奨）

```bash
# テスト環境をビルド
make test-build

# テストを実行
make test

# ビルドとテストを一度に実行
make test-all

# インタラクティブシェルを起動（手動テスト用）
make test-shell

# テストイメージをクリーンアップ
make test-clean

# ヘルプを表示
make help
```

### 2. スクリプトを直接使用する方法

```bash
# テスト環境をビルド
./test/run-test.sh --build

# テストを実行
./test/run-test.sh --test

# インタラクティブシェルを起動（--rm付き）
./test/run-test.sh --shell

# ビルドしてからテスト
./test/run-test.sh --build --test

# クリーンアップ
./test/run-test.sh --clean

# ヘルプを表示
./test/run-test.sh --help
```

## テスト項目

テストスクリプト（`test/test.sh`）は以下をチェックします：

### 1. 環境チェック
- chezmoi、brew、gitのインストール確認
- 各ツールのバージョン表示

### 2. Chezmoiリポジトリの確認
- Chezmoiソースディレクトリの存在確認
- Gitリポジトリの初期化確認
- リモートリポジトリURLの確認
- `.chezmoidata.toml`の存在確認

### 3. スクリプト構文チェック
- `.chezmoiscripts/`内の全スクリプトの構文検証

### 4. 適用済みDotfilesの検証
- ホームディレクトリに適用されたdotfiles（.bashrc、.vimrc、.tmux.conf、.zshrc）の確認

### 5. Chezmoiの状態確認
- `chezmoi status`の実行確認
- `chezmoi verify`の検証

### 6. ソースDotfilesの検証
- Chezmoiソースディレクトリ内のdotfilesの存在確認

## インタラクティブシェルでの手動テスト

`make test-shell`または`./test/run-test.sh --shell`を実行すると、Ubuntu環境のシェルに接続できます：

```bash
# シェルに接続
make test-shell

# コンテナ内で以下が利用可能（dotfilesは既に適用済み）
testuser@container:~$ chezmoi status
testuser@container:~$ chezmoi diff
testuser@container:~$ ls -la ~/  # 適用されたdotfilesを確認

# Chezmoiソースディレクトリを確認
testuser@container:~$ cd ~/.local/share/chezmoi
testuser@container:~/.local/share/chezmoi$ git remote -v
testuser@container:~/.local/share/chezmoi$ git log --oneline -5

# 終了（コンテナは--rmで自動削除されます）
testuser@container:~$ exit
```

## トラブルシューティング

### Dockerイメージのビルドに失敗する

```bash
# キャッシュをクリアして再ビルド
docker build --no-cache -t chezmoi-dotfiles-test:ubuntu22.04 -f test/Dockerfile.ubuntu test/
```

### テストが失敗する

```bash
# インタラクティブシェルで詳細を確認
make test-shell

# コンテナ内でテストスクリプトを手動実行
/dotfiles/test/test.sh
```

### Homebrewのインストールが遅い

Homebrewのインストールには時間がかかる場合があります（5-10分程度）。初回のイメージビルド時は特に時間がかかりますが、ビルドキャッシュにより2回目以降は高速化されます。

## ディレクトリ構造

```
.
├── test/
│   ├── Dockerfile.ubuntu       # Ubuntu 22.04テスト環境
│   ├── test.sh                 # 自動テストスクリプト
│   └── run-test.sh             # テスト実行ヘルパー
├── Makefile                    # 簡単なコマンド実行用
└── docs/
    └── testing.md              # このファイル
```

## 注意事項

- Dockerイメージのビルド時に、GitHubリポジトリから`chezmoi init --apply`が実行されます
- テストコンテナは`--rm`フラグで起動されるため、終了時に自動削除されます
- テスト用ユーザー`testuser`はsudo権限を持っています（パスワード不要）
- イメージビルドには時間がかかります（Homebrewのインストールとdotfilesの適用で5-10分程度）
