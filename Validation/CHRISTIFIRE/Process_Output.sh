#!/bin/bash
PDIR=..
CUR=`pwd`
DIR=`basename $CUR`
 
WDIR=$PDIR/$DIR/FDS_Output_Files
DDIR=Current_Results
cp $DDIR/CHRISTIFIRE*devc.csv $WDIR
cp $DDIR/*git.txt $WDIR
