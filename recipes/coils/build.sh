#!/bin/sh
set -x -e

# Coils Dir
COILS_DIR=${PREFIX}/share/coils
#list programs
COILS_PROGRAMS="coils-svr.pl coils-wrap.pl"




# remove the precompilated one
rm ncoils-linux
#compile
${CC} -O2 -I. -o ncoils-osf ncoils.c read_matrix.c -lm

# get the name of the ncoils program build
NCOILS=$(ls ncoils-*)

# info for debugging
ls -l

# copy tools in the bin
mkdir -p ${PREFIX}/bin
mkdir -p ${COILS_DIR}
cp -r * ${COILS_DIR}

# Add main tools
cp ${NCOILS} ${PREFIX}/bin/ncoils

# Add extra programs
for PROGRAM in ${COILS_PROGRAMS} ; do
  cp ${PROGRAM} ${PREFIX}/bin
done

# You then need to set an environment variable $COILSDIR to the coils folder
# These coils folder is installed as runtime deps, but the paths to it need to
# to reflect the current environment's $PREFIX/bin dir.
mkdir -p ${PREFIX}/etc/conda/activate.d ${PREFIX}/etc/conda/deactivate.d
cat <<EOF >> ${PREFIX}/etc/conda/activate.d/coils.sh
export COILSDIR=${COILS_DIR}
EOF

cat <<EOF >> ${PREFIX}/etc/conda/deactivate.d/coils.sh
unset COILSDIR
EOF
