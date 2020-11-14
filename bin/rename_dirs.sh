#!/usr/bin/env bash

# pushd 52594
# mv 'Dicom kolor' 'dicom color'
# popd

for i in $(find . -type d -depth 1)
do
  pushd $i
  mv 'obraz podstawowy' image_base
  mv 'nifti kolor' nifti_color
  mv 'dicom kolor' dicom_color
  popd
done

echo
echo "Done with renaming folders."
