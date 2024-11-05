#!/bin/sh
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RESET="\033[0m"
TEST_DIR="__tests__"
ARCH=$(uname -m)
OS=$(uname)
EXE=""
case "$ARCH" in
    aarch64)
        if [ "$OS" = "Linux" ]; then
            EXE="zig-out/aarch64-linux/zcloc"
        elif [ "$OS" = "Darwin" ]; then
            EXE="zig-out/aarch64-macos/zcloc"
        fi
        ;;
    x86_64)
        if [ "$OS" = "Linux" ]; then
            EXE="zig-out/x86_64-linux-gnu/zcloc"
        fi
        ;;
    *)
        echo -e "${RED}Unsupported architecture: $ARCH${RESET}\n"
        exit 1
        ;;
esac
echo -e "${CYAN}RUN duplicater.sh${RESET}"
bash ./duplicater.sh
if [ ! -f "$EXE" ]; then
    echo -e "${RED}Executable not found: $EXE${RESET}\n"
    exit 1
fi
echo -e "${GREEN}Running $EXE with arguments: $TEST_DIR${RESET}\n"
"$EXE" "$TEST_DIR"
EXEC_STATUS=$?
if [ $EXEC_STATUS -eq 0 ]; then
    echo -e "${GREEN}Execution of $EXE completed successfully.${RESET}\n"
else
    echo -e "${RED}There was an error during execution of $EXE. Check log for details.${RESET}\n"
fi
echo -e "${YELLOW}Cleaning up duplicated test files...${RESET}"
rm -f ./__tests__/test{1..1000}.c
echo -e "${GREEN}Duplicated test.c files deleted.${RESET}\n"
