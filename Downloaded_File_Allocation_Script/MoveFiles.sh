#!/bin/bash

declare -a FileTypes 

user=$(whoami)

fileTypes=(Setup Anime)

Downloads_Directory_Is_Empty(){
  directoryPath=$1

  if [ -e $directoryPath ]; then 
    return 1;
  else
    return 0;
  fi

}


Valid_Directory () {
  directoryExists=$1

  echo "Validating existence of destined directory..."

  if [ -d $directoryExists ]; then
    echo "Directory $folderName exists..."
    return 0
  else
    return 1
  fi
}

Create_Directory () {
  directoryToCreate=$1

  echo "Creating directory: $directoryToCreate..."

  mkdir $directoryToCreate

  echo "Created directory: $directoryToCreate..."

}

Move_Files () {
  folderName=$1
  fileName=$2

  echo -e "\n$fileName found..."

  if Valid_Directory $folderName; then
     echo "Moving $fileName to $folderName..." 
     mv $fileName $folderName
  else
    Create_Directory $folderName
  fi
}

Main () {
  find . -type f | while IFS= read fileName; do
    case "${fileName,,*}" in
      *anime* )
        Move_Files "C:/anime" $fileName
        ;;
      *setup* )
        Move_Files "C:/setup" $fileName
        ;;
      *dnd* )  
        Move_Files "C:/dnd" $fileName
        ;;
      * ) 
        echo "Don't know what to do with $fileName"
    esac
  done

  echo "All files operated on... exiting"
}

Run_Script () {

  downloadsDirectory="C:/Users/$user/Downloads"

   if Downloads_Directory_Is_Empty $downloadsDirectory; then
    echo "Downloads directory is currently empty... exiting"
   else
    cd $downloadsDirectory
    #Prompt for permission to edit/create folders
    Main
   fi

}

Run_Script