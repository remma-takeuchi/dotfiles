#!/usr/bin/env bash
set -euo pipefail

# カラー出力
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 設定
IMAGE_NAME="chezmoi-dotfiles-test"
IMAGE_TAG="ubuntu22.04"
CONTAINER_NAME="chezmoi-test-$(date +%s)"

# スクリプトのディレクトリ
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# ヘルプメッセージ
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Docker-based testing environment for chezmoi dotfiles.

OPTIONS:
    --build         Build the Docker image
    --test          Run automated tests
    --shell         Start an interactive shell (with --rm)
    --clean         Remove test Docker images
    --help          Show this help message

EXAMPLES:
    # Build the test image
    $(basename "$0") --build

    # Run automated tests
    $(basename "$0") --test

    # Start an interactive shell for manual testing
    $(basename "$0") --shell

    # Build and test
    $(basename "$0") --build --test

    # Clean up
    $(basename "$0") --clean
EOF
}

# Docker イメージをビルド
build_image() {
    echo -e "${BLUE}Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}${NC}"

    if docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" -f "${SCRIPT_DIR}/Dockerfile.ubuntu" "${SCRIPT_DIR}"; then
        echo -e "${GREEN}✓ Image built successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to build image${NC}"
        return 1
    fi
}

# テストを実行
run_tests() {
    echo -e "${BLUE}Running automated tests...${NC}"

    docker run --rm \
        --name "${CONTAINER_NAME}" \
        "${IMAGE_NAME}:${IMAGE_TAG}" \
        /bin/bash -l -c 'bash /home/testuser/.local/share/chezmoi/test/test.sh'

    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ All tests passed${NC}"
    else
        echo -e "${RED}✗ Tests failed${NC}"
    fi

    return $exit_code
}

# インタラクティブシェルを起動
run_shell() {
    echo -e "${BLUE}Starting interactive shell...${NC}"
    echo -e "${YELLOW}Note: Container will be removed on exit (--rm)${NC}"
    echo -e "${YELLOW}Dotfiles are already applied from: https://github.com/remma-takeuchi/dotfiles.git${NC}"
    echo ""

    docker run --rm -it \
        --name "${CONTAINER_NAME}" \
        "${IMAGE_NAME}:${IMAGE_TAG}" \
        /bin/bash -l
}

# Docker イメージをクリーンアップ
clean_images() {
    echo -e "${BLUE}Cleaning up Docker images...${NC}"

    if docker images "${IMAGE_NAME}" -q | grep -q .; then
        docker rmi $(docker images "${IMAGE_NAME}" -q) || true
        echo -e "${GREEN}✓ Images cleaned${NC}"
    else
        echo -e "${YELLOW}No images to clean${NC}"
    fi
}

# メイン処理
main() {
    local should_build=false
    local should_test=false
    local should_shell=false
    local should_clean=false

    # 引数がない場合はヘルプを表示
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    # 引数解析
    while [[ $# -gt 0 ]]; do
        case $1 in
            --build)
                should_build=true
                shift
                ;;
            --test)
                should_test=true
                shift
                ;;
            --shell)
                should_shell=true
                shift
                ;;
            --clean)
                should_clean=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    # クリーンアップ
    if [ "$should_clean" = true ]; then
        clean_images
        exit 0
    fi

    # ビルド
    if [ "$should_build" = true ]; then
        build_image || exit 1
    fi

    # イメージの存在確認
    if ! docker images "${IMAGE_NAME}:${IMAGE_TAG}" -q | grep -q .; then
        echo -e "${YELLOW}Image not found. Building...${NC}"
        build_image || exit 1
    fi

    # テスト実行
    if [ "$should_test" = true ]; then
        run_tests
        exit $?
    fi

    # シェル起動
    if [ "$should_shell" = true ]; then
        run_shell
        exit $?
    fi
}

main "$@"
