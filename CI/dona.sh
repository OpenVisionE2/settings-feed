#!/bin/bash

# Script by jbleyel for https://github.com/oe-alliance

PVER="1.0"
PR="r0"
PACK="dona"
LOCAL="local"
GITREPRO="OpenVisionE2/Dona-settings"
PACKNAME="enigma2-plugin-settings-dona"
D=$(pwd) &> /dev/null
PD=${D}/$LOCAL
B=${D}/build
TMP=${D}/tmp
R=${D}/feed
Homepage="https://github.com/OpenVisionE2/Dona-settings"

function MakeIPK ()
{

    rm -rf ${B}
    rm -rf ${TMP}
    mkdir -p ${B}
    mkdir -p ${TMP}
    mkdir -p ${TMP}/CONTROL

    mkdir -p ${TMP}/etc/enigma2/
    cp -rp ${PD}/$1/* ${TMP}/etc/enigma2/

cat > ${TMP}/CONTROL/control << EOF
Package: ${PACKNAME}-${2}
Version: ${3}
Description: ${PACK} enigma2 settings ${2}
Section: base
Priority: optional
Maintainer: Open Vision developers <forum.openvision.tech>
License: Proprietary
Architecture: all
OE: ${PACKNAME}-${2}
Source: ${Homepage}
EOF

	tar -C ${TMP}/CONTROL -czf ${B}/control.tar.gz .
	rm -rf ${TMP}/CONTROL

    PKG="${PACKNAME}-${2}_${3}_all.ipk"
    tar -C ${TMP} -czf ${B}/data.tar.gz .
    echo "2.0" > ${B}/debian-binary
	cd ${B}
	ls -l
	ar -r ${R}/${PKG} ./debian-binary ./control.tar.gz ./data.tar.gz 
	cd ${D}

}

GITCOMMITS=$(curl  --silent -I -k "https://api.github.com/repos/$GITREPRO/commits?per_page=1" | sed -n '/^[Ll]ink:/ s/.*"next".*page=\([0-9]*\).*"last".*/\1/p')
GITHASH=$(git ls-remote https://github.com/$GITREPRO HEAD | sed -e 's/^\(.\{7\}\).*/\1/')
OLDHASH=$(head -n 1 $PACK.hash 2>/dev/null)

FORCECHECK=`cat force`

if [ "$OLDHASH" == "$GITHASH" ] && [ "$FORCECHECK" == "no" ]; then
    exit 0
fi
echo $GITHASH > $PACK.hash
rm -rf ${PD}
git clone --depth 1 ${Homepage} local

VER="$PVER+git$GITCOMMITS+${GITHASH}_r0"

mkdir -p ${R}

rm -rf ${D}/feed/${PACKNAME}*.ipk

MakeIPK 16E_Dona_E2 16e ${VER}
MakeIPK 19E+13E_Dona_E2 19e-13e ${VER}
MakeIPK 19E+16E+13E+1.9E+1W_Dona_E2 19e-16e-13e-1.9e-1w ${VER}
MakeIPK 19E+16E+13E+1.9E_Dona_E2 19e-16e-13e-1.9e ${VER}
MakeIPK 19E+16E+13E+1W_Dona_E2 19e-16e-13e-1w ${VER}
MakeIPK 19E+16E+13E+4.8E+1W_Dona_E2 19e-16e-13e-4.8e-1w ${VER}
MakeIPK 19E+16E+13E_Dona_E2 19e-16e-13e ${VER}
MakeIPK 19E+16E_Dona_E2 19e-16e ${VER}
MakeIPK 19E_Dona_E2 19e ${VER}
MakeIPK 23.5E+19E+16E+13E+1.9E+1W_Dona_E2 23.5e-19e-16e-13e-1.9e-1w ${VER}
MakeIPK 23.5E+19E+16E+13E+9E_Dona_E2 23.5e-19e-16e-13e-9e ${VER}
MakeIPK 23.5E+19E+16E+13E_Dona_E2 23.5e-19e-16e-13e ${VER}
MakeIPK 28E+19E+16E+13E_Dona_E2 28e-19e-16e-13e ${VER}
MakeIPK 28E+23.5E+19E+16E+13E+9E+4.8E+1.9E+1W+4W+5W_Dona_E2 28e-23.5e-19e-16e-13e-9e-4.8e-1w-4w-5w ${VER}
MakeIPK 28E+23.5E+19E+16E+13E+9E+4.8E+1W_Dona_E2 28e-23.5e-19e-16e-13e-9e-4.8e-1w ${VER}
MakeIPK 28E+23.5E+19E+16E+13E+9E+7E+4.8E+1.9E+1W_Dona_E2 28e-23.5e-19e-16e-13e-9e-7e-4.8e-1.9e-1w ${VER}
MakeIPK 28E+23.5E+19E+16E+13E+9E+1.9E+1W_Dona_E2 28e-23.5e-19e-16e-13e-9e-1.9e-1w ${VER}
MakeIPK 39E+23.5E+19E+16E+13E+9E+1.9E+1W_Dona_E2 39e-23.5e-19e-16e-13e-9e-1.9e-1w ${VER}
MakeIPK 39E+28E+23.5E+19E+16E+13E+10E+9E+4.8E+1.9E+1W_Dona_E2 39e-28e-23.5e-19e-16e-13e-10e-9e-4.8e-1.9e-1w ${VER}
MakeIPK 39E+28E+23.5E+19E+16E+13E+1.9E+1W_Dona_E2 39e-28e-23.5e-19e-16e-13e-1.9e-1w ${VER}
MakeIPK 39E+28E+23.5E+19E+16E+13E+9E+7E+4.8E+1W+5W+27.5W_Dona_E2 39e-28e-23.5e-19e-16e-13e-9e-7e-4.8e-1w-5w-27.5w ${VER}

MakeIPK Motor_28E-30W_Dona_E2 motor-28e-30w ${VER}
MakeIPK Motor_42E-30W_Dona_E2 motor-42e-30w ${VER}
MakeIPK Motor_75E-30W_Dona_E2 motor-75e-30w ${VER}
MakeIPK Motor_90E-45W_Dona_E2 motor-90e-45w ${VER}
