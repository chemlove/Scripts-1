#!/bin/bash
set -eu
COUNTER=1
mkdir -p trajs

for dir in e*
do
    (
    echo "$dir"
    cd trajs || exit
    if [ ! -f "./run_$(printf %02d ${COUNTER})_${dir}.nc" ]
    then
        echo "parm ../striped.prmtop
        trajin ../${dir}/Production.filtered.nc
        autoimage
        trajout ./run_$(printf %02d ${COUNTER})_${dir}.nc" >> cmds.cpptraj
        cpptraj -i cmds.cpptraj
        rm cmds.cpptraj
    fi
    

    )
    ((COUNTER++))
    # do min image script
    (
    cd $dir || exit
    if [ ! -f '*pdb' ]
    then
        min_image.py ../striped.prmtop Production.filtered.nc
    fi
    )
done

