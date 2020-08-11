#!/bin/bash
mkdir -p export

required_applications="ansible mas"

function requires {
    if ! command -v brew &> /dev/null
    then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
    echo "Installing required applications..."
    brew install $required_applications
}

function clean_up {
    brew remove $required_applications
}

function export_machine_settings {us
    echo "exporting settings..."
    mkdir -p export/defaults

    defaults export -globalDomain export/defaults/globalDomain.plist

    for i in `defaults domains | tr ',' '\n'`
    do
        defaults export $i export/defaults/$i.plist
    done
}

function export_application_settings {
    rsync -a --prune-empty-dirs --include '*/' --include '*.plist' --exclude '*' ~/Library export/
}

function export_app_store_apps {
    mkdir -p export/app_store
    mas list | cut -f 1 -d ' ' > export/app_store/installed_app_ids.txt
}

requires
export_machine_settings
export_application_settings
export_app_store_apps

echo "Done!"
