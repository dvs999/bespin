#!/bin/sh

if [ -z $1 ]; then
    echo -e "\nUsage: $0 /path/to/presets [allusers]\n\n" \
    "allusers: requires root privilegues and will\n" \
    "          install the presets for all known logins\n\n" \
    "This will install all *.bespin preset files found in the passed directory\n"
    exit
fi

if [ "$1" = "__install" ]; then
    echo "Installing for user: `id -un`"
    if [ -d "$2" ]; then
        for preset in "$2"/*.bespin; do
            bespin update "$preset"
        done
    fi
    exit
fi

src_path="`realpath $1`"

if [ ! -d "$src_path" ]; then
    echo "The directory \"$src_path\" does not exist"
    exit
fi

if [ "$2" = "allusers" ]; then
    echo
    if [ "`id -u`" != "0" ]; then
        echo "allusers requires root privilegues, trying sudo"
        sudo $0 "$@"
        exit
    fi
    while IFS=':' read -a login; do
        if [ -d "${login[5]}" ] && grep "${login[6]}" /etc/shells >/dev/null 2>&1; then
            su - "${login%%:*}" -c "`realpath $0` __install \"$src_path\""
        fi
    done < /etc/passwd
else
    `realpath $0` __install "`realpath $1`"
fi