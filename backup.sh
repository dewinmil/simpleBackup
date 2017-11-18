#!/bin/bash


if [ ! -d "~/.backup" ]; then
  mkdir -p ~/.backup
fi


if [ $# -eq 0 ]; then
  echo "The usage of this command is: backup [options] targetFileList"
  echo "Type --help for more information"
fi


while [[ $# -gt 0 ]]
do
key="$1"

  #find number of directories in ~/backup
  #do this up here to prevent copy paste
  num=$(find ~/.backup/ -type d | wc -l)
  num=$((num - 1)) #-1 because it count's .backup as well 

case $key in
    -n)
      echo "Number of Files: $(find ~/.backup -type f | wc -l)"
      echo "Number of Subdirectories: $num"
      echo ""
      shift
    ;;
    -l)
      ls -R ~/.backup
      echo ""
      shift
    ;;
    -ln)
      ls -R ~/.backup
      echo ""
      echo "Number of Files: $(find ~/.backup -type f | wc -l)"
      echo "Number of Subdirectories: $num"
      echo ""
      shift 
    ;;
    -nl)
      echo "Number of Files: $(find ~/.backup -type f | wc -l)"
      echo "Number of Subdirectories: $num"
      echo ""
      ls -R ~/.backup
      echo ""
      shift 
    ;;
    --help)
      echo "Simple bash script intended to backup files and directories."
      echo "Use Cases:"
      echo "-l Prints a list of all files and directories stored in ~/.backup"
      echo "-n Prints the number of files and directories stored in ~/.backup"
      echo "<filename> copies file into ~/backup - overwrites existing files of the same name"
      echo "<directory name> copies directory and it's contents into ~/.backup" 
      echo "note that any files  with identical filenames will be overwritten" 
      echo "<targetFileList> if you input a file specifically named targetFileList"
      echo "then each line in the file will be read individually and should that line"
      echo "be a valid file or directory it will be copied into ~/.backup"
      echo ""
      shift
    ;;
    targetFileList)
      max=$(wc -l < targetFileList)
      for ((i=1; i<=$max; i++))
        do
          filename=$(sed -n ${i}p targetFileList)
          if [ "$filename" == "" ]; then
            :  #blank space / do nothing
          elif [ -f "$filename" ]; then
            echo "Adding File" 
            cp $filename ~/.backup
            echo ""
          elif [ -d "$filename" ]; then
            echo "Adding Directory" 
            cp -r $filename ~/.backup
            echo ""
          else
            echo "$filename does not exist!"
            echo ""
          fi
        done
      shift
    ;;
    *)    
    addr="$(pwd)/$key"
    if [ -d "$addr" ]; then
      echo "Adding Directory"
      cp -r $addr ~/.backup
      echo ""
    elif [ -f "$addr" ]; then
        echo "Adding File" 
        cp $addr ~/.backup
        echo ""
    else
      echo "backup: invalid argument $key"      
    fi

    shift # past argument
    ;;
esac
done
