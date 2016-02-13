#!/bin/bash

  # remove the folder created by a previous run from the script
  rm -r color_images 2>/dev/null
  # create otuput directory
  mkdir color_images
  # find all files whose name end in .tif
  images=$(find *.tiff)

  #iterate over them
  for im in ${images[*]}
  do
     # check if the output from identify contains the word "gray"
     identify $im | grep -q -i gray

     # $? gives the exit code of the last command, in this case grep, it will be zero if a coincidense was found
     if [ $? -eq 0 ]
     then
        echo $im is gray
     else
        echo $im is color
        cp $im color_images
     fi
  done
