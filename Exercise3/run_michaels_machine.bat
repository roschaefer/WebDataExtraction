@echo off

:: Check if an argument was provided
:: ---------------------------------

if [%1] == [] goto usage

:: Start the various jobs
:: ----------------------
echo [INFO] Retrieving information for artist: %1%


:: Create directories
::-------------------
echo [INFO] Creating temporary directories
mkdir out
mkdir temp

:: Copy files
:: ----------
echo [INFO] Copying some files...
cp wrappers\integration.xslt out\integration.xslt
cp wrappers\dummy.xml out\dummy.xml
cp wrappers\concert_dates\songkick.txt temp\songkick.txt
cp wrappers\products\amazon.txt temp\amazon.txt


:: Replacing ARTIST_NAME with real artist name
:: -------------------------------------------
echo [INFO] Replacing string "ARTIST_NAME" with %1%
util\fart -- temp\amazon.txt ARTIST_NAME %1%
util\fart -- temp\songkick.txt ARTIST_NAME %1%
util\fart -- out\integration.xslt ARTIST_NAME %1%


:: Start xulrunner (needed for Oxpath)
:: -----------------------------------
echo [INFO] Starting xulrunner
oxpath\xulrunner\win32\xulrunner --register-user


:: Wrapper: Youtube Videos
:: -----------------------
echo [INFO] Searching for youtube videos
javac wrappers\youtube\YoutubeExtractor.java -cp wrappers\youtube\jsoup-1.7.1.jar;wrappers\youtube\commons-lang3-3.1.jar -d temp\
java -Dfile.encoding=UTF-8 -classpath wrappers\youtube\jsoup-1.7.1.jar;wrappers\youtube\commons-lang3-3.1.jar;temp\ YoutubeExtractor %1%
mv youtube.xml out\


:: Wrapper: Songkick Concert Dates
:: -------------------------------
echo [INFO] Searching for concert dates
java -Dfile.encoding=UTF-8 -jar oxpath\win32\oxpath-win32.jar --xml temp\songkick.txt > out\songkick.xml


:: Wrapper: Amazon Products
:: ------------------------
echo [INFO] Searching for products on amazon
java -Dfile.encoding=UTF-8 -jar oxpath\win32\oxpath-win32.jar --xml temp\amazon.txt > out\amazon.xml


:: Wrapper: Discogs Discography
:: ----------------------------
echo [INFO] Searching for discography on discogs
ruby wrappers\discogs\discogsExtractor.rb -a %1% > out\discogs.xml


:: Wrapper: Flickr Images
:: ----------------------
echo [INFO] Searching for images on flickr
ruby wrappers\images\flickr.rb -a %1%
mv flickr.xml out\


:: Error Handling: I don't know why, but the 1st line created by oxpath is always garbage -> remove it
:: ---------------------------------------------------------------------------------------------------
echo [INFO] Removing garbage from oxpath output files
java -Dfile.encoding=UTF-8 -classpath util\ OxpathGarbageRemover out\songkick.xml
java -Dfile.encoding=UTF-8 -classpath util\ OxpathGarbageRemover out\amazon.xml


:: Integration using xslt
:: ----------------------
echo [INFO] Integrating .xml files using XSLT
java -jar util\saxon9.jar out\dummy.xml out\integration.xslt > integrated_data.html


:: Clean up
:: --------
echo [INFO] Cleaning up
del temp\ /f /s /q
del out\ /f /s /q
rmdir temp\
rmdir out\


GOTO END


:: Print usage message
:: -------------------
:USAGE
echo.
echo [USAGE]: %0% name_of_an_artist
echo.


:END