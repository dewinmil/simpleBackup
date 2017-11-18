#!/bin/bash


if [ ! -d "~/.backup" ]; then
  mkdir -p ~/.backup
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
      echo "My Help Message"
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
      echo "My Help Message"
      echo ""
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
