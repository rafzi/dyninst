get libelf. for example: http://www.mr511.de/software/english.html (tested version 0.8.13)
replace build.bat in lib/ with the file from patches/
execute build.bat
this will create a folder libelf_install

get libdwarf: for example: https://www.prevanders.net/dwarf.html#releases (tested version "20160613")
copy the folder libelf_install from libelfs lib/ directory next to the downloaded libdwarf folder (not inside)
copy the VC folder from patches/ into the downloaded libdwarf folder
go into the VC folder there and build with cmake
install with cmake to a desired location