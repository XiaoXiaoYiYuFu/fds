#!/bin/bash

# this script is called by BUNDLE_linux64.sh and BUNDLE_osx64.sh

errlog=/tmp/errlog.$$

# -------------------- SCP -------------------

SCP ()
{
  HOST=$1
  FROMDIR=$2
  FROMFILE=$3
  TODIR=$4
  TOFILE=$5
  scp $HOST\:$FROMDIR/$FROMFILE $TODIR/$TOFILE 2>/dev/null
  if [ -e $TODIR/$TOFILE ]; then
    echo "$FROMFILE copied from host:$HOST"
  else
    echo "***error: $TOFILE not copied to bundle from $HOST at $FROMDIR/$FROMFILE " >> $errlog
  fi
}

# -------------------- CP -------------------

CP ()
{
  FROMDIR=$1
  FROMFILE=$2
  TODIR=$3
  TOFILE=$4
  if [ ! -e $FROMDIR/$FROMFILE ]; then
    echo "***error: the file $FROMFILE does not exist"
  else
    cp $FROMDIR/$FROMFILE $TODIR/$TOFILE
  fi
  if [ -e $TODIR/$TOFILE ]; then
    echo "$FROMFILE copied"
  else
    echo "***error: $FROMFILE not copied to bundle" >> $errlog
  fi
}

# -------------------- UNTAR -------------------

UNTAR ()
{
  FROMDIR=$1
  FROMFILE=$2
  TODIR=$3
  TODIR2=$4
  if [ ! -e $FROMDIR/$FROMFILE ]; then
    echo "***error: the compressed file $FROMFILE does not exist"
  else
    curdir=`pwd`
    cd $TODIR
    tar xvf $FROMDIR/$FROMFILE
    cd $curdir
  fi
  if [ -e $TODIR/$TODIR2 ]; then
    echo "$FROMFILE untar'd"
  else
    echo "***error: $FROMFILE not untar'd to bundle" >> $errlog
  fi
}

# -------------------- CP2 -------------------

CP2 ()
{
  FROMDIR=$1
  FROMFILE=$2
  TODIR=$3
  TOFILE=$FROMFILE
  if [ ! -e $FROMDIR/$FROMFILE ]; then
    echo "***error: the file $FROMFILE does not exist"
  else
    cp $FROMDIR/$FROMFILE $TODIR/$TOFILE
  fi
  if [ -e $TODIR/$TOFILE ]; then
    echo "$FROMFILE copied"
  else
    echo "***error: $FROMFILE not copied to bundle" >> $errlog
  fi
}

# -------------------- CPDIR -------------------

CPDIR ()
{
  FROMDIR=$1
  TODIR=$2
  if [ ! -e $FROMDIR ]; then
    echo "***error: the directory $FROMDIR does not exist"
  else
    echo "*******************************"
    echo copying directory from $FROMDIR to $TODIR
    echo "*******************************"
    cp -r $FROMDIR $TODIR
  fi
  if [ -e $TODIR ]; then
    echo "$FROMDIR copied"
  else
    echo "***error: the directory $FROMDIR not copied to bundle" >> $errlog
  fi
}

# -------------------- CPDIRFILES -------------------

CPDIRFILES ()
{
  FROMDIR=$1
  TODIR=$2
  if [ ! -e $FROMDIR ]; then
    echo "***error: the directory $FROMDIR does not exist"
  else
    echo "*******************************"
    echo copying files from directory $FROMDIR to $TODIR
    echo "*******************************"
    cp $FROMDIR/* $TODIR/.
  fi
  if [ -e $TODIR ]; then
    echo "$FROMDIR copied"
  else
    echo "***error: unable to copy $FROMDIR" >> $errlog
  fi
}

# VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
if [ "`uname`" == "Darwin" ]; then
  FDSOS=_osx_64
  PLATFORM=OSX64
else
  FDSOS=_linux_64
  PLATFORM=LINUX64
fi


manifest=manifest$FDSOS.html

smokeviewdir=intel$FDSOS
smokeview=smokeview$FDSOS

smokezipdir=intel$FDSOS
smokezip=smokezip$FDSOS

dem2fdsdir=intel$FDSOS
dem2fds=dem2fds$FDSOS

wind2fdsdir=intel$FDSOS
wind2fds=wind2fds$FDSOS

hashfiledir=intel$FDSOS
hashfile=hashfile$FDSOS

smokediffdir=intel$FDSOS
smokediff=smokediff$FDSOS

backgrounddir=intel$FDSOS
background=background

openmpidir=~/FDS_Guides

if [ "$MPI_VERSION" == "INTEL" ]; then
  fdsmpidir=impi_intel$FDSOS
  fdsmpi=fds_impi_intel$FDSOS
else
  fdsmpidir=mpi_intel$FDSOS
  fdsmpi=fds_mpi_intel$FDSOS
fi

fds2asciidir=intel$FDSOS
fds2ascii=fds2ascii$FDSOS

scp_fds_smvroot=$fds_smvroot
fds_smvroot=~/$fds_smvroot
fdsroot=$scp_fds_smvroot/fds/Build
backgroundroot=$scp_fds_smvroot/smv/Build/background
smokediffroot=$scp_fds_smvroot/smv/Build/smokediff
smokeziproot=$scp_fds_smvroot/smv/Build/smokezip
dem2fdsroot=$scp_fds_smvroot/smv/Build/dem2fds
smvscriptdir=$scp_fds_smvroot/smv/scripts
wind2fdsroot=$scp_fds_smvroot/smv/Build/wind2fds
hashfileroot=$scp_fds_smvroot/smv/Build/hashfile
uploaddir=$fds_smvroot/fds/Utilities/uploads
bundledir=$bundlebase
webpagesdir=$fds_smvroot/webpages
mandir=~/FDS_Guides
smvbindir=$scp_fds_smvroot/smv/Build/smokeview/$smokeviewdir
fds_bundle=$fds_smvroot/fds/Utilities/Scripts/for_bundle
smv_bundle=$fds_smvroot/smv/for_bundle
texturedir=$smv_bundle/textures
fds2asciiroot=$scp_fds_smvroot/fds/Utilities/fds2ascii
makeinstaller=$fds_smvroot/fds/Utilities/Scripts/make_installer.sh

fds_cases=$fds_smvroot/fds/Verification/FDS_Cases.sh
fds_benchamrk_cases=$fds_smvroot/fds/Verification/FDS_Benchmark_Cases.sh
smv_cases=$fds_smvroot/smv/Verification/scripts/SMV_Cases.sh
wui_cases=$fds_smvroot/smv/Verification/scripts/WUI_Cases.sh
copyfdscase=$fds_smvroot/fds/Utilities/Scripts/copyfdscase.sh
copycfastcase=$fds_smvroot/fds/Utilities/Scripts/copycfastcase.sh
FDSExamplesDirectory=$fds_smvroot/fds/Verification
SMVExamplesDirectory=$fds_smvroot/smv/Verification

cd $uploaddir
rm -rf $bundlebase
mkdir $bundledir
mkdir $bundledir/bin
mkdir $bundledir/bin/LIB64
mkdir $bundledir/bin/hash
mkdir $bundledir/Documentation
mkdir $bundledir/Examples
mkdir $bundledir/bin/textures

echo ""
echo "--- copying programs ---"
echo ""

# smokeview

SCP $fdshost $backgroundroot/$backgrounddir $background $bundledir/bin background
SCP $smvhost $smvbindir                     $smokeview  $bundledir/bin smokeview
SCP $fdshost $smokediffroot/$smokediffdir   $smokediff  $bundledir/bin smokediff
SCP $fdshost $smokeziproot/$smokezipdir     $smokezip   $bundledir/bin smokezip
SCP $fdshost $dem2fdsroot/$dem2fdsdir       $dem2fds    $bundledir/bin dem2fds
SCP $fdshost $wind2fdsroot/$wind2fdsdir     $wind2fds   $bundledir/bin wind2fds
SCP $fdshost $hashfileroot/$hashfiledir     $hashfile   $bundledir/bin hashfile

CURDIR=`pwd`
cd $bundledir/bin
hashfile background > hash/background.sha1
hashfile smokeview  > hash/smokeview.sha1
hashfile smokediff  > hash/smokediff.sha1
hashfile smokezip   > hash/smokezip.sha1
hashfile dem2fds    > hash/dem2fds.sha1
hashfile wind2fds   > hash/wind2fds.sha1
hashfile hashfile   > hash/hashfile.sha1
cd $CURDIR

SCP $fdshost $smvscriptdir jp2conv.sh $bundledir/bin jp2conv.sh
CPDIR $texturedir $bundledir/bin

# FDS 

SCP $fdshost $fdsroot/$fdsmpidir          $fdsmpi    $bundledir/bin fds
SCP $fdshost $fds2asciiroot/$fds2asciidir $fds2ascii $bundledir/bin fds2ascii

CURDIR=`pwd`
cd $bundledir/bin
hashfile fds       > hash/fds.sha1
hashfile fds2ascii > hash/fds2ascii.sha1
cd $CURDIR

if [ "$MPI_VERSION" != "INTEL" ]; then
  if [ "$PLATFORM" == "LINUX64" ]; then
    openmpifile=openmpi_${MPI_VERSION}_linux_64.tar.gz
  fi
  if [ "$PLATFORM" == "OSX64" ]; then
    openmpifile=openmpi_${MPI_VERSION}_osx_64.tar.gz
  fi
fi

echo ""
echo "--- copying configuration files ---"
echo ""

CP $fds_bundle README_repo.html   $bundledir/Documentation README_repo.html

CP $smv_bundle smokeview.ini $bundledir/bin smokeview.ini

CP $smv_bundle volrender.ssf $bundledir/bin volrender.ssf

CP $smv_bundle objects.svo   $bundledir/bin objects.svo

if [ "$MPI_VERSION" != "INTEL" ]; then
  CP $openmpidir $openmpifile  $bundledir/bin $openmpifile
fi

echo ""
echo "--- copying documentation ---"
echo ""
CP2 $mandir FDS_Config_Management_Plan.pdf $bundledir/Documentation
CP2 $mandir FDS_Technical_Reference_Guide.pdf $bundledir/Documentation
CP2 $mandir FDS_User_Guide.pdf $bundledir/Documentation
CP2 $mandir FDS_Validation_Guide.pdf $bundledir/Documentation
CP2 $mandir FDS_Verification_Guide.pdf $bundledir/Documentation
CP2 $mandir SMV_User_Guide.pdf $bundledir/Documentation
CP2 $mandir SMV_Technical_Reference_Guide.pdf $bundledir/Documentation
CP2 $mandir SMV_Verification_Guide.pdf $bundledir/Documentation


if [ ! "$INTELBINDIR" == "" ]; then
  if [ -d $HOME/$INTELBINDIR ]; then
    if [ "$MPI_VERSION" == "INTEL" ]; then
    echo ""
    echo "--- copying Intel exe's ---"
    echo ""
      CP $HOME/$INTELBINDIR mpiexec   $bundledir/bin mpiexec
      CP $HOME/$INTELBINDIR pmi_proxy $bundledir/bin pmi_proxy
    fi
  fi
fi
if [ "$INTELLIBDIR" != "" ]; then
  if [ -d $HOME/$INTELLIBDIR ]; then

    echo ""
    echo "--- copying compiler run time libraries ---"
    echo ""
    CP $HOME/$INTELLIBDIR libiomp5.so      $bundledir/bin/LIB64 libiomp5.so
    CP $HOME/$INTELLIBDIR libmpifort.so.12 $bundledir/bin/LIB64 libmpifort.so.12
    CP $HOME/$INTELLIBDIR libmpi.so.12     $bundledir/bin/LIB64 libmpi.so.12
  fi
fi
if [ "$OSLIBDIR" != "" ]; then
  if [ -d $HOME/$OSLIBDIR ]; then

    echo ""
    echo "--- copying miscellaneous run time libraries ---"
    echo ""
    CPDIRFILES $HOME/$OSLIBDIR $bundledir/bin/LIB64
  fi
fi

echo ""
echo "--- copying release notes ---"
echo ""
CP $fds_bundle FDS_Release_Notes.htm $bundledir/Documentation FDS_Release_Notes.html

CP $webpagesdir smv_readme.html $bundledir/Documentation SMV_Release_Notes.html


# CP2 $fds_bundle readme_examples.html $bundledir/Examples

export OUTDIR=$uploaddir/$bundledir/Examples
export QFDS=$copyfdscase
export RUNTFDS=$copyfdscase
export RUNCFAST=$copycfastcase

echo ""
echo "--- copying example files ---"
echo ""
cd $FDSExamplesDirectory
$fds_cases
$fds_benchmark_cases
cd $SMVExamplesDirectory
$wui_cases
$smv_cases
rm -rf $OUTDIR/Immersed_Boundary_Method

cd $curdir

echo ""
echo "--- building archive ---"
echo ""
rm -rf $uploaddir/$bundlebase.tar
rm -rf $uploaddir/$bundlebase.tar.gz
cd $uploaddir/$bundlebase
tar cf ../$bundlebase.tar --exclude='*.csv' .
echo Compressing archive
gzip    ../$bundlebase.tar
echo Creating installer
cd ..
$makeinstaller -i $bundlebase.tar.gz -d $INSTALLDIR $bundlebase.sh

cat $bundledir/bin/hash/*.sha1 >  $bundlebase.sha1
hashfile $bundlebase.sh        >> $bundlebase.sha1

if [ -e $errlog ]; then
  numerrs=`cat $errlog | wc -l `
  if [ $numerrs -gt 0 ]; then
    echo ""
    echo "----------------------------------------------------------------"
    echo "---------------- bundle generation errors ----------------------"
    cat $errlog
    echo "----------------------------------------------------------------"
    echo "----------------------------------------------------------------"
    echo ""
  fi
  rm $errlog
fi

