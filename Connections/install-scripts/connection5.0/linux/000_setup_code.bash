#!/bin/bash

BASE_DIR=/opt/install
ZIP_DIR=$BASE_DIR/downloads
DEST_DIR=/opt/install/packages

declare -a wasfixes=("8.5.5.1-ws-was-ifpm94437.zip" "8.5.5.1-ws-wasprod-ifpi15998.zip" "8.5.5.1-ws-wasprod-ifpm91417.zip")
declare -a connectionsfixes=("5.0.0.0-IC-Multi-IFLO80688.jar" "5.0.0.0-IC-Multi-IFLO80986.jar" "5.0.0.0-IC-Multi-IFLO80990.jar" "5.0.0.0-IC-Multi-IFLO81049.jar")
INSTALLER_IM=agent.installer.linux.gtk.x86_1.7.3000.20140521_1925.zip
INSTALLER_DB2=DB2_ESE_10_Linux_x86-64.tar.gz
INSTALLER_DB2LICENCE=DB2_ESE_Restricted_QS_Activation_10.zip
INSTALLER_DB2FP4=v10.1fp4_linuxx64_universal_fixpack.tar.gz
INSTALLER_TDI=TDI_IDENTITY_E_V7.1.1_LIN-X86-64.tar
INSTALLER_TDIFP3=7.1.1-TIV-TDI-FP0003.zip
INSTALLER_WAS855_1=WASND_v8.5.5_1of3.zip
INSTALLER_WAS855_2=WASND_v8.5.5_2of3.zip
INSTALLER_WAS855_3=WASND_v8.5.5_3of3.zip
INSTALLER_WAS855SUPP_1=WAS_V8.5.5_SUPPL_1_OF_3.zip
INSTALLER_WAS855SUPP_2=WAS_V8.5.5_SUPPL_2_OF_3.zip
INSTALLER_WAS855SUPP_3=WAS_V8.5.5_SUPPL_3_OF_3.zip
INSTALLER_WAS855FP1_1=8.5.5-WS-WAS-FP0000001-part1.zip
INSTALLER_WAS855FP1_2=8.5.5-WS-WAS-FP0000001-part2.zip
INSTALLER_WAS855SUPPFP1_1=8.5.5-WS-WASSupplements-FP0000001-part1.zip
INSTALLER_WAS855SUPPFP1_2=8.5.5-WS-WASSupplements-FP0000001-part2.zip
INSTALLER_CONNECTIONS=IBM_Connections_5.0_Lin.tar

IBMIM_BASE=ibmim
DB2_BASE=db2
DB2LICENCE_BASE=db2_licence
DB2FP4_BASE=db2fp4
TDI_BASE=tdi
TDIFP3_BASE=tdifp3
WAS_BASE=was855
WASSUPP_BASE=was855supp
WASFP_BASE=was855fp1
WASSUPPFP_BASE=was855suppfp1
WASFIXES_BASE=was855fp1_fixes
CONNECTIONS_BASE=connections
CONNECTIONSFIXES_BASE=connections

read -p "Purge existing target directories inside $DEST_DIR (y/n)? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -rf $DEST_DIR/$IBMIM_BASE
	rm -rf $DEST_DIR/$DB2_BASE
	rm -rf $DEST_DIR/$DB2FP4_BASE
	rm -rf $DEST_DIR/$DB2LICENCE_BASE
	rm -rf $DEST_DIR/$TDI_BASE
	rm -rf $DEST_DIR/$TDIFP3_BASE
	rm -rf $DEST_DIR/$WAS_BASE
	rm -rf $DEST_DIR/$WASSUPP_BASE
	rm -rf $DEST_DIR/$WASFP_BASE
	rm -rf $DEST_DIR/$WASSUPPFP_BASE
	rm -rf $DEST_DIR/$WASFIXES_BASE
	rm -rf $DEST_DIR/$CONNECTIONS_BASE
	rm -rf $DEST_DIR/$CONNECTIONSFIXES_BASE
fi

mkdir -p $DEST_DIR/$IBMIM_BASE
mkdir -p $DEST_DIR/$DB2_BASE
mkdir -p $DEST_DIR/$DB2LICENCE_BASE
mkdir -p $DEST_DIR/$DB2FP4_BASE
mkdir -p $DEST_DIR/$TDI_BASE
mkdir -p $DEST_DIR/$TDIFP3_BASE
mkdir -p $DEST_DIR/$WAS_BASE
mkdir -p $DEST_DIR/$WASSUPP_BASE
mkdir -p $DEST_DIR/$WASFP_BASE
mkdir -p $DEST_DIR/$WASSUPPFP_BASE
mkdir -p $DEST_DIR/$WASFIXES_BASE
mkdir -p $DEST_DIR/$CONNECTIONS_BASE
mkdir -p $DEST_DIR/$CONNECTIONSFIXES_BASE

echo ""
echo "looking for $INSTALLER_IM"
PKG=`find $ZIP_DIR -name $INSTALLER_IM -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o $PKG -d $DEST_DIR/$IBMIM_BASE > /dev/null 2>&1
else
    echo "$INSTALLER_IM not found!"
fi

echo ""
echo "looking for $INSTALLER_DB2"
PKG=`find $ZIP_DIR -name $INSTALLER_DB2 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    tar -C $DEST_DIR/$DB2_BASE -xvf $PKG > /dev/null 2>&1
else
    echo "$INSTALLER_DB2 not found!"
fi

echo ""
echo "looking for $INSTALLER_DB2LICENCE"
PKG=`find $ZIP_DIR -name $INSTALLER_DB2LICENCE -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o $PKG -d $DEST_DIR/$DB2LICENCE_BASE > /dev/null 2>&1
else
    echo "$INSTALLER_IM not found!"
fi

echo ""
echo "looking for $INSTALLER_DB2FP4"
PKG=`find $ZIP_DIR -name $INSTALLER_DB2FP4 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    tar -C $DEST_DIR/$DB2FP4_BASE -xvf $PKG > /dev/null 2>&1
else
    echo "$INSTALLER_DB2FP4 not found!"
fi

echo ""
echo "looking for $INSTALLER_TDI"
PKG=`find $ZIP_DIR -name $INSTALLER_TDI -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    tar -C $DEST_DIR/$TDI_BASE -xvf "$PKG" > /dev/null 2>&1
else
    echo "$INSTALLER_TDI not found!"
fi

echo ""
echo "looking for $INSTALLER_TDIFP3"
PKG=`find $ZIP_DIR -name $INSTALLER_TDIFP3 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$TDIFP3_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_TDI not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855_1"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855_1 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WAS_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855_1 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855_2"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855_2 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WAS_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855_2 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855_3"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855_3 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WAS_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855_3 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855SUPP_1"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855SUPP_1 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASSUPP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855SUPP_1 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855SUPP_2"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855SUPP_2 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASSUPP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855SUPP_2 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855SUPP_3"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855SUPP_3 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WAS_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855SUPP_3 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855FP1_1"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855FP1_1 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASFP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855FP1_1 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855FP1_2"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855FP1_2 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASFP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855FP1_2 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855SUPPFP1_1"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855SUPPFP1_1 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASSUPPFP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855FP1_1 not found!"
fi

echo ""
echo "looking for $INSTALLER_WAS855SUPPFP1_2"
PKG=`find $ZIP_DIR -name $INSTALLER_WAS855SUPPFP1_2 -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    unzip -o "$PKG" -d "$DEST_DIR/$WASSUPPFP_BASE" > /dev/null 2>&1
else
    echo "$INSTALLER_WAS855FP1_2 not found!"
fi

echo ""
echo "looking for WAS fixes ..."
for i in "${wasfixes[@]}"
do
    echo -e "\tworking on $i"
    PKG=`find "$ZIP_DIR" -name "$i" -print`
    if [ -n "$PKG" ]; then
        echo -e "\t\t Copying $PKG ..."
        cp "$PKG" "$DEST_DIR/$WASFIXES_BASE/"
    else
        echo -e "\t\t$i not found!"
    fi
done

echo ""
echo "looking for $INSTALLER_CONNECTIONS"
PKG=`find "$ZIP_DIR" -name "$INSTALLER_CONNECTIONS" -print`
if [ -n "$PKG" ]; then
    echo "Unpacking $PKG ..."
    tar -C "$DEST_DIR/$CONNECTIONS_BASE" -xvf "$PKG" > /dev/null 2>&1
else
    echo "$INSTALLER_CONNECTIONS not found!"
fi

echo "looking for Connections fixes ..."
for i in "${connectionsfixes[@]}"
do
    echo -e  "\tworking on $i"
    PKG=`find "$ZIP_DIR" -name "$i" -print`
    if [ -n "$PKG" ]; then
        echo -e "\t\t Copying $PKG| ..."
        cp "$PKG" "$DEST_DIR/$CONNECTIONSFIXES_BASE/"
    else
        echo -e "\t\t$i not found!"
    fi
done

