.PHONY: help packages-check packages-install packages-upgrade test test-build test-shell test-clean

# chezmoi の template data から profile を取得する。必要に応じて
# `make packages-install PROFILE=work` のように上書きできる。
PROFILE ?= $(shell chezmoi execute-template '{{ .profile }}' 2>/dev/null)

# デフォルトターゲット: ヘルプを表示
help:
	@echo "Chezmoi Dotfiles - Test Commands"
	@echo ""
	@echo "Usage:"
	@echo "  make test-build    Build the Docker test image"
	@echo "  make test          Run automated tests in Docker"
	@echo "  make test-shell    Start an interactive shell in Docker (with --rm)"
	@echo "  make test-clean    Clean up Docker test images"
	@echo "  make test-all      Build and run tests"
	@echo "  make packages-check                 Check Brewfile dependencies"
	@echo "  make packages-install [PROFILE=...] Install missing Brewfile dependencies"
	@echo "  make packages-upgrade [PROFILE=...] Upgrade Brewfile dependencies"
	@echo ""

# Brewfile の同期は明示的に行う。通常の chezmoi apply では、Brewfile の
# 内容が変わったときだけ run_onchange_ スクリプトが不足分を導入する。
packages-check:
	@CHEZMOI_PROFILE="$(PROFILE)" bash ./scripts/brew-bundle.sh --check

packages-install:
	@CHEZMOI_PROFILE="$(PROFILE)" bash ./scripts/brew-bundle.sh --no-upgrade

packages-upgrade:
	@CHEZMOI_PROFILE="$(PROFILE)" bash ./scripts/brew-bundle.sh --upgrade

# Docker イメージをビルド
test-build:
	@./test/run-test.sh --build

# テストを実行
test:
	@./test/run-test.sh --test

# ビルドしてからテストを実行
test-all:
	@./test/run-test.sh --build --test

# インタラクティブシェルを起動
test-shell:
	@./test/run-test.sh --shell

# Docker イメージをクリーンアップ
test-clean:
	@./test/run-test.sh --clean
