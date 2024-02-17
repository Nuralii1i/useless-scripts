#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

GENTOO_MIRRORS="https://mirrors.ustc.edu.cn/gentoo"

GREEN="\033[0;32m"
PURPLE="\033[0;35m"
NC="\033[0m"
RED_BOLD="\033[1;31m"

COLUMNS=$(tput cols)

package_name=$1

find /var/db/repos/gentoo/ -type d -name *"${package_name}"* | while read dir_path; do
    manifest_path="${dir_path}/Manifest"
    if [ -f "$manifest_path" ]; then
        grep -o 'DIST[^ ]* [^ ]*' "$manifest_path" | while read line; do
	    dist_value=$(echo "$line" | cut -d' ' -f2)
            b2sum_result=$(echo -n "$dist_value" | b2sum -)
            hash_short=${b2sum_result:0:2}
	    echo -e $'\U1F595'" Dist: ${dist_value} ${GREEN}->${NC} ${GENTOO_MIRRORS}/distfiles/${hash_short}"
	    echo -e "${PURPLE}"$(printf '%*s' "$((COLUMNS-1))" '=' | tr ' ' '=')"${NC}"
        done
    fi
done
