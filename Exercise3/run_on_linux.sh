#!/bin/bash
## run_on_linux.sh a shell script to bundle web scraper tools


##  Print usage message
##  -------------------
## USAGE

function usage() {
echo
echo [USAGE]: %0% name_of_an_artist
echo
}


##  Check if an argument was provided
##  ---------------------------------

[[ $# -eq 0 ]] && usage


##  Start the various jobs
##  ----------------------
echo [INFO] Retrieving information for artist: $1


##  Create directories
## -------------------
echo [INFO] Creating temporary directories
mkdir out
mkdir temp

##  Copy files
##  ----------
echo [INFO] Copying some files...
cp ./wrappers/integration.xslt ./out/integration.xslt
cp ./wrappers/dummy.xml ./out/dummy.xml
cp ./wrappers/concert_dates/songkick.txt ./temp/songkick.txt
cp ./wrappers/products/amazon.txt ./temp/amazon.txt


##  Replacing ARTIST_NAME with real artist name
##  -------------------------------------------
echo [INFO] Replacing string "ARTIST_NAME" with $1

OLD="ARTIST_NAME"
NEW=$1
declare -a SourceFiles=('temp/amazon.txt' 'temp/songkick.txt' 'out/integration.xslt')
for f in $SourceFiles
do
    if [ -f $f -a -r $f ]; then
        sed -i "s/$OLD/$NEW/g" "$f"
    else
        echo "Error: Cannot read $f"
    fi
done

#:: Start xulrunner (needed for Oxpath)
#:: -----------------------------------
#echo [INFO] Starting xulrunner
#oxpath\xulrunner\win32\xulrunner --register-user


#:: Wrapper: Youtube Videos
#:: -----------------------
#echo [INFO] Searching for youtube videos
#javac wrappers\youtube\YoutubeExtractor.java -cp wrappers\youtube\jsoup-1.7.1.jar;wrappers\youtube\commons-lang3-3.1.jar -d temp\
#java -classpath wrappers\youtube\jsoup-1.7.1.jar;wrappers\youtube\commons-lang3-3.1.jar;temp\ YoutubeExtractor "%1%"
#mv youtube.xml out\


#:: Wrapper: Songkick Concert Dates
#:: -------------------------------
#echo [INFO] Searching for concert dates
#java -jar oxpath\win32\oxpath-win32.jar --xml temp\songkick.txt > out\songkick.xml


#:: Wrapper: Amazon Products
#:: ------------------------
#echo [INFO] Searching for products on amazon
#java -jar oxpath\win32\oxpath-win32.jar --xml temp\amazon.txt > out\amazon.xml


#:: Wrapper: Discogs Discography
#:: ----------------------------
#echo [INFO] Searching for discography on discogs
#ruby wrappers\discogs\discogsExtractor.rb -a %1% > out\discogs.xml


#:: Error Handling: I don't know why, but the 1st line created by oxpath is always garbage -> remove it
#:: ---------------------------------------------------------------------------------------------------
#echo [INFO] Removing garbage from oxpath output files
#java -classpath util\ OxpathGarbageRemover out\songkick.xml
#java -classpath util\ OxpathGarbageRemover out\amazon.xml


#:: Integration using xslt
#:: ----------------------
#echo [INFO] Integrating .xml files using XSLT
#java -jar util\saxon9.jar out\dummy.xml out\integration.xslt > integrated_data.html





#:: TODO - remove me !!!
#GOTO END







#:: Clean up
#:: --------
#echo [INFO] Cleaning up
#del temp\ /f /s /q
#del out\ /f /s /q
#rmdir temp\
#rmdir out\


#GOTO END


