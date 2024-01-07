#!/bin/bash

# Make sure snap is gone
if command -v snap &> /dev/null; then
    echo "Removing snap"
    while true; do
        # Get a list of all installed Snap packages
        snap_list=$(sudo snap list --all | tail -n +2 | awk '!/disabled/{print $1}')

        # If there are no more Snap packages installed, exit the loop
        if [ -z "$snap_list" ]; then
            break
        fi

        # Loop through the list and remove each Snap package
        for package in $snap_list; do
            sudo snap remove $package > /dev/null 2>&1
            # Check if the removal was successful
            if [ $? -eq 0 ]; then
                echo "Removed: $package"
            fi
        done
    done
    echo "All Snap packages have been removed."

    sudo systemctl stop snapd > /dev/null 2>&1
    sudo systemctl disable snapd > /dev/null 2>&1
    sudo systemctl mask snapd > /dev/null 2>&1
    sudo apt purge snapd -y > /dev/null 2>&1
    sudo apt autoremove > /dev/null 2>&1
    sudo apt-mark hold snapd > /dev/null 2>&1
    echo "Snap service removed"

    rm -rf $HOME/snap/ 
    sudo rm -rf /snap
    sudo rm -rf /var/snap
    sudo rm -rf /var/lib/snapd
    echo "Removed snap files"
fi

