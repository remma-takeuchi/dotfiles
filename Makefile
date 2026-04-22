.PHONY: help test test-build test-shell test-clean

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
	@echo ""

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
