#!/usr/bin/env bash

###############################################################################
# InfraPulse Common Library
###############################################################################

# These variables are intended to be used by scripts that source this file.

# shellcheck disable=SC2034
PROJECT="InfraPulse"

# shellcheck disable=SC2034
VERSION="1.0.0"

# shellcheck disable=SC2034
AUTHOR="Abhishek"

# shellcheck disable=SC2034
LICENSE="MIT"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LOG_DIR="$ROOT_DIR/logs"
REPORT_DIR="$ROOT_DIR/reports"
CONFIG_DIR="$ROOT_DIR/config"

mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"
