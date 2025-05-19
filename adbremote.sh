#!/bin/bash

#defining color codes
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"
RED="\e[31m"
GREEN="\e[32m"

#printing banner of app
echo -e "${RED}
██████╗  █████╗ ██╗      ███╗   ███╗ ██████╗ ████████╗███████╗
██╔══██╗██╔══██╗██║      ████╗ ████║██╔═══██╗╚══██╔══╝██╔════╝
██║  ██║███████║██║█████╗██╔████╔██║██║   ██║   ██║   █████╗  
██║  ██║██╔══██║██║╚════╝██║╚██╔╝██║██║   ██║   ██║   ██╔══╝  
██████╔╝██║  ██║███████╗ ██║ ╚═╝ ██║╚██████╔╝   ██║   ███████╗
╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═╝     ╚═╝ ╚═════╝    ╚═╝   ╚══════╝
${CYAN}-------------${YELLOW}Direct ADB Link Remote by ${GREEN}cybercena${CYAN}-------------${RESET}"
echo " "
echo "Select device type:"
echo "1. Mobile (Pair first)"
echo "2. TV (Direct connect)"
read -p "Choice [1/2]: " device_type

if [ "$device_type" = "1" ]; then
    read -p "Enter pairing IP:PORT (e.g., 192.168.1.100:37029): " pair_target
    adb pair "$pair_target"
    read -p "Enter connection IP:PORT (e.g., 192.168.1.100:5555): " device_ip
    adb connect "$device_ip"
elif [ "$device_type" = "2" ]; then
    read -p "Enter device IP:PORT (e.g., 192.168.1.101:5555): " device_ip
    adb connect "$device_ip"
else
    echo "Invalid choice"
    exit 1
fi

# TV MENU
if [ "$device_type" = "2" ]; then
    while true; do
        echo "--- TV Remote ---"
        echo "1. Home"
        echo "2. Back"
        echo "3. Mute"
        echo "4. Power"
        echo "5. Volume Up"
        echo "6. Volume Down"
        echo "7. Disconnect"
        echo "8. Youtube"
        echo "9. Enter text"
        echo "10. OK"
        echo "11. External command"
        echo "12. Browser"
        echo "13. Up"
        echo "14. Down"
        echo "15. Left"
        echo "16. Right"
        echo "99. Exit"
        read -p "Choose option: " choice

        case $choice in
            1) adb shell input keyevent KEYCODE_HOME ;;
            2) adb shell input keyevent KEYCODE_BACK ;;
            3) adb shell input keyevent KEYCODE_MUTE ;;
            4) adb shell input keyevent KEYCODE_POWER ;;
            5) adb shell input keyevent KEYCODE_VOLUME_UP ;;
            6) adb shell input keyevent KEYCODE_VOLUME_DOWN ;;
            7) adb disconnect "$device_ip" ;;
            8) adb shell monkey -p com.google.android.youtube.tv -c android.intent.category.LAUNCHER 1 ;;
            9) 
                read -p "Enter text to send: " text
                adb shell input text "$text"
                ;;
            10) adb shell input keyevent KEYCODE_DPAD_CENTER ;;
            11)
                read -p "Enter any adb command (without 'adb'): " user_cmd
                adb $user_cmd
                ;;
            12)
                adb shell monkey -p com.android.chrome -c android.intent.category.LAUNCHER 1 || adb shell monkey -p com.android.browser -c android.intent.category.LAUNCHER 1
                ;;
            13) adb shell input keyevent KEYCODE_DPAD_UP ;;
            14) adb shell input keyevent KEYCODE_DPAD_DOWN ;;
            15) adb shell input keyevent KEYCODE_DPAD_LEFT ;;
            16) adb shell input keyevent KEYCODE_DPAD_RIGHT ;;
            99) 
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid option"
                ;;
        esac

    done
fi

# MOBILE MENU
if [ "$device_type" = "1" ]; then
    while true; do
        echo ""
        echo "--- Mobile Remote ---"
        echo "1. Home"
        echo "2. Back"
        echo "3. Screenshot"
        echo "4. Input Text"
        echo "5. Open App (Package Name)"
        echo "6. Disconnect"
        echo "7. Exit"
        read -p "Choose option: " choice

        case $choice in
            1) adb shell input keyevent KEYCODE_HOME ;;
            2) adb shell input keyevent KEYCODE_BACK ;;
            3) adb shell screencap -p /sdcard/screen.png && echo "Saved to device /sdcard/screen.png" ;;
            4) read -p "Enter text to input: " text; adb shell input text "$text" ;;
            5) read -p "Enter package name (e.g., com.android.chrome): " pkg; adb shell monkey -p "$pkg" -c android.intent.category.LAUNCHER 1 ;;
            6) adb disconnect "$device_ip" ;;
            7) echo "Exiting..."; break ;;
            *) echo "Invalid option" ;;
        esac
    done
fi
