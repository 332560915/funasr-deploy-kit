#!/usr/bin/env bash

# 公共库总入口。
# 场景脚本只需要 source 本文件；具体函数按职责拆到多个小文件中，避免单文件膨胀。

# 场景脚本在 source 本文件前必须先定义 SCRIPT_DIR。
# 这里不使用 BASH_SOURCE，是为了兼容一些精简 bash 环境。
COMMON_DIR="${SCRIPT_DIR}/lib"

# shellcheck source=core.sh
. "${COMMON_DIR}/core.sh"
# shellcheck source=checks.sh
. "${COMMON_DIR}/checks.sh"
# shellcheck source=docker.sh
. "${COMMON_DIR}/docker.sh"
# shellcheck source=runtime.sh
. "${COMMON_DIR}/runtime.sh"
