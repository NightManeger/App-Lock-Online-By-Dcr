#!/bin/bash

# Colors
NOCOLOR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'

# Key Server
KEY_SERVER="https://raw.githubusercontent.com/NightManeger/App-Lock-Online-By-Dcr/main/Password.html"

# Telegram Link
TELEGRAM_LINK="https://t.me/DCR_OWNER"

# Function to Check Key Online
check_key() {
    local KEY="$1"
    local VALID_KEYS=$(curl -s "$KEY_SERVER" | tr -d '\r')

    if [[ "$VALID_KEYS" == *"$KEY"* ]]; then
        return 0  # Key Verified
    fi

    return 1  # Invalid Key
}

# Function to Show Banner
show_banner() {
    clear
    echo -e "${RED}██████╗░░█████╗░██████╗░  ${YELLOW}███╗░░░███╗░█████╗░██████╗░░██████╗"
    echo -e "${RED}██╔══██╗██╔══██╗██╔══██╗  ${YELLOW}████╗░████║██╔══██╗██╔══██╗██╔════╝"
    echo -e "${WHITE}██║░░██║██║░░╚═╝██████╔╝  ${CYAN}██╔████╔██║██║░░██║██║░░██║╚█████╗░"
    echo -e "${WHITE}██║░░██║██║░░██╗██╔══██╗  ${CYAN}██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗"
    echo -e "${GREEN}██████╔╝╚█████╔╝██║░░██║  ${BLUE}██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝"
    echo -e "${GREEN}╚═════╝░░╚════╝░╚═╝░░╚═╝  ${BLUE}╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░"
    echo -e "${WHITE}══════════════════════════════════════════${NOCOLOR}"
    echo -e "${GREEN}🔰 DCR TOOL - FILE DUMPER TOOL 🔰${NOCOLOR}"
    echo -e "${WHITE}══════════════════════════════════════════${NOCOLOR}"
}

# Function to Display Home Menu
home_menu() {
    show_banner
    echo -e "${GREEN}✅ AUTHENTICATION SUCCESSFUL!${NOCOLOR}"
    echo -e "${WHITE}══════════════════════════════════════════${NOCOLOR}"
    echo -e "${YELLOW}[1] START CHECK"
    echo -e "[2] EXIT${NOCOLOR}"
    echo
    read -p "👉 SELECT OPTION: " OPTION

    if [[ "$OPTION" -eq 1 ]]; then
        start_check
    else
        echo -e "${CYAN}👋 Exiting...${NOCOLOR}"
        exit 0
    fi
}

# Function to Start File Check
start_check() {
    show_banner
    echo -e "${CYAN}📂 Enter the path to the directory with EDITED files:${NOCOLOR}"
    read -r EDITED_PATH
    echo -e "${CYAN}📂 Enter the path to the directory with ORIGINAL files:${NOCOLOR}"
    read -r ORIGINAL_PATH
    echo -e "${CYAN}💾 Enter the path to save MODIFIED files:${NOCOLOR}"
    read -r OUTPUT_PATH

    # Validate Directories
    if [[ ! -d "$EDITED_PATH" || ! -d "$ORIGINAL_PATH" ]]; then
        echo -e "${RED}❌ ERROR: One or more directories do not exist!${NOCOLOR}"
        sleep 2
        home_menu
        return
    fi

    mkdir -p "$OUTPUT_PATH"
    echo -e "${GREEN}🔍 STARTING FILE CHECK...${NOCOLOR}"
    sleep 1

    # Optimized File Checking
    find "$EDITED_PATH" -type f | while read -r FILE_PATH; do
        RELATIVE_PATH="${FILE_PATH#$EDITED_PATH/}"  # Get relative path
        ORIGINAL_FILE="$ORIGINAL_PATH/$RELATIVE_PATH"
        OUTPUT_FILE="$OUTPUT_PATH/$RELATIVE_PATH"

        if [[ -f "$ORIGINAL_FILE" ]]; then
            if ! cmp -s "$FILE_PATH" "$ORIGINAL_FILE"; then
                mkdir -p "$(dirname "$OUTPUT_FILE")"
                cp "$FILE_PATH" "$OUTPUT_FILE"
                echo -e "${RED}[MODIFIED] $RELATIVE_PATH → Copied to Output Folder${NOCOLOR}"
            else
                echo -e "${GREEN}[MATCH] $RELATIVE_PATH → No Changes${NOCOLOR}"
            fi
        else
            mkdir -p "$(dirname "$OUTPUT_FILE")"
            cp "$FILE_PATH" "$OUTPUT_FILE"
            echo -e "${YELLOW}[NEW FILE] $RELATIVE_PATH → Not in Original Folder${NOCOLOR}"
        fi
    done

    echo -e "${GREEN}✅ CHECK COMPLETED!${NOCOLOR}"
    sleep 2
    home_menu  # Return to Home Menu after task completion
}

# LOGIN SYSTEM (No Auto-Login)
for i in {1..3}; do
    show_banner
    echo -e "${CYAN}🔑 Enter your Access Key:${NOCOLOR}"
    read -s -p "👉 " USER_KEY
    echo ""

    if check_key "$USER_KEY"; then
        unset USER_KEY  # Clear key from memory
        home_menu
    else
        echo -e "${RED}❌ Invalid Key! Attempts Left: $((3-i))${NOCOLOR}"
        sleep 2
    fi
done

echo -e "${RED}❌ Too many failed attempts! Opening Telegram...${NOCOLOR}"
sleep 2
termux-open-url "$TELEGRAM_LINK"  # Open Telegram Link in Termux
exit 1
