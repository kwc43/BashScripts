#!/bin/bash
declare -a itemsToDownload

#Dictionary maybe? Tuple
itemsToDownload=(Spotify Acrobat_Reader Nord_Vpn Firefox Java_Runtime_Envirnonment NodeJs Python MingW 7-Zip Git Putty Cmder Visual_C++_Redsitributable) 
chocoCommand=(spotify adobereader nordvpn firefox jre8 nodejs python mingw 7zip git putty putty cmder vcredist140)

numberOfItems=${#itemsToDownload[@]}

function Prompt_User {
    while true; do
    read -p "This script will download ${numberOfItems}, do you wish to run this script? [Y/N]" yn
        case $yn in
            [Yy]* ) Download_Items; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    echo "Done"
}

function Download_Items {
    for ((i=0; i<$numberOfItems; i++));
        do 
            echo -e "Installing ${itemsToDownload[i]} \n"
            choco install ${chocoCommand[i]} -y
    done 
}

Prompt_User




