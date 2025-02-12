#!/bin/bash

# Colors
NOCOLOR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
MAGENTA='\033[1;35m'

# GitHub Key URL
GITHUB_KEY_URL="https://raw.githubusercontent.com/NightManeger/App-Lock-Online-By-Dcr/main/Password.html"

# Protected Script Path (Anti-Copy)
PROTECTED_PATH="/data/data/com.termux/files/home/dcrtool.sh"

# Hash Verification (Anti-Modification)
SCRIPT_HASH="e99a18c428cb38d5f260853678922e03"

# Function: Show Banner
show_banner() {
    clear
    echo -e "${RED}██████╗░░█████╗░██████╗░  ${YELLOW}███╗░░░███╗░█████╗░██████╗░░██████╗"
    echo -e "${RED}██╔══██╗██╔══██╗██╔══██╗  ${YELLOW}████╗░████║██╔══██╗██╔══██╗██╔════╝"
    echo -e "${WHITE}██║░░██║██║░░╚═╝██████╔╝  ${CYAN}██╔████╔██║██║░░██║██║░░██║╚█████╗░"
    echo -e "${WHITE}██║░░██║██║░░██╗██╔══██╗  ${CYAN}██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗"
    echo -e "${GREEN}██████╔╝╚█████╔╝██║░░██║  ${CYAN}██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝"
    echo -e "${GREEN}╚═════╝░░╚════╝░╚═╝░░╚═╝  ${CYAN}╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░"
    echo -e "${WHITE}══════════════════════════════════════════${NOCOLOR}"
    echo -e "${GREEN}🔰 DCR TOOL - FILE CHECK & ZIP EXTRACTOR 🔰${NOCOLOR}"
    echo -e "${WHITE}══════════════════════════════════════════${NOCOLOR}"
}

# Function: Check GitHub Key
check_key() {
    local USER_KEY="$1"
    local VALID_KEYS=$(curl -s "$GITHUB_KEY_URL" | tr -d '\r')

    if [[ "$VALID_KEYS" == *"$USER_KEY"* ]]; then
        return 0  # Valid Key
    fi
    return 1  # Invalid Key
}

# Anti-Copy Protection
if [[ "$(realpath "$0")" != "$PROTECTED_PATH" ]]; then
    echo -e "${RED}⚠️ ERROR: Copy Detected! This script cannot be moved.${NOCOLOR}"
    exit 1
fi

# Anti-Modification Protection
CURRENT_HASH=$(md5sum "$0" | awk '{print $1}')
if [[ "$CURRENT_HASH" != "$SCRIPT_HASH" ]]; then
    echo -e "${RED}⚠️ ERROR: Unauthorized Modification Detected!${NOCOLOR}"
    exit 1
fi

# Authentication System
for i in {1..3}; do
    show_banner
    echo -e "${CYAN}🔑 Enter Your Access Key:${NOCOLOR}"
    read -s USER_KEY

    if check_key "$USER_KEY"; then
        unset USER_KEY  # Clear key from memory
        break
    else
        echo -e "${RED}❌ Invalid Key! Attempts Left: $((3-i))${NOCOLOR}"
        sleep 2
    fi
done

if [[ "$i" -eq 3 ]]; then
    echo -e "${RED}⛔ Too Many Failed Attempts! Redirecting to Telegram...${NOCOLOR}"
    sleep 2
    termux-open-url "https://t.me/DCR_OWNER"
    exit 1
fi

# Main Menu
home_menu() {
    show_banner
    echo -e "${YELLOW}[1] START FILE CHECK"
    echo -e "[2] EXTRACT ZIP FILE"
    echo -e "[3] EXIT${NOCOLOR}"
    echo
    read -p "👉 SELECT OPTION: " OPTION

    if [[ "$OPTION" -eq 1 ]]; then
        start_file_check
    elif [[ "$OPTION" -eq 2 ]]; then
        extract_zip
    else
        exit 0
    fi
}

# Function: File Check
start_file_check() {
    show_banner
    echo -e "${RED}🔎 Enter path to directory with EDITED files:${RESET}"
    read EDITED_PATH
    echo -e "${GREEN}🔎 Enter path to directory with ORIGINAL files:${RESET}"
    read ORIGINAL_PATH
    echo -e "${YELLOW}💾 Enter path to save MODIFIED files:${RESET}"
    read OUTPUT_PATH

    if [[ ! -d "$EDITED_PATH" || ! -d "$ORIGINAL_PATH" ]]; then
        echo -e "${RED}❌ ERROR: One or both directories do not exist.${RESET}"
        exit 1
    fi

    mkdir -p "$OUTPUT_PATH"

    show_banner
    echo -e "${GREEN}🚀 STARTING FILE CHECK...${RESET}"
    sleep 1

    export EDITED_PATH ORIGINAL_PATH OUTPUT_PATH GREEN RESET RED CYAN

    ls "$EDITED_PATH" | xargs -P 8 -I {} bash -c '
        FILE="{}"
        if cmp -s "$EDITED_PATH/$FILE" "$ORIGINAL_PATH/$FILE"; then
            echo -e "${CYAN}✅ [MATCH] $FILE${RESET}"
        else
            cp "$EDITED_PATH/$FILE" "$OUTPUT_PATH"
            echo -e "${RED}🔥 [MODIFIED] $FILE → Copied to Output Folder${RESET}"
        fi
    '

    echo -e "${GREEN}🎯 DONE! FILE CHECK COMPLETED SUCCESSFULLY! ✓${RESET}"
    sleep 2
    home_menu
}

# Function: Extract ZIP
extract_zip() {
    show_banner
    echo -e "${CYAN}📂 Enter the path to the ZIP file:${NOCOLOR}"
    read -r ZIP_FILE
    echo -e "${CYAN}📂 Enter the destination folder for extracted files:${NOCOLOR}"
    read -r OUTPUT_DIR

    if [[ ! -f "$ZIP_FILE" ]]; then
        echo -e "${RED}❌ ERROR: ZIP file not found!${NOCOLOR}"
        sleep 2
        home_menu
        return
    fi

    mkdir -p "$OUTPUT_DIR"

    echo -e "${GREEN}🔓 Extracting ZIP file, please wait...${NOCOLOR}"
    unzip -q "$ZIP_FILE" -d "$OUTPUT_DIR" &
    wait

    echo -e "${GREEN}✅ Extraction Completed!${NOCOLOR}"
    sleep 2
    home_menu
}

# Start Menu
home_menu
