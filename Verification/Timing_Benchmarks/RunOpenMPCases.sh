#!/bin/bash

export JOBPREFIX=MP_
OUTFILE=openmp_summary.csv
QFDS="../../Utilities/Scripts/qfds.sh  -P -I  -t -q aspen " 
NCASES=2

#---------------------------------------------
#                   wait_cases_end
#---------------------------------------------

wait_cases_end()
{
   # Scans qstat and waits for cases to end
     while [[ `qstat -a | awk '{print $2 $4}' | grep $(whoami) | grep $JOBPREFIX` != '' ]]; do
        JOBS_REMAINING=`qstat -a | awk '{print $2 $4}' | grep $(whoami) | grep $JOBPREFIX | wc -l`
        echo "Waiting for ${JOBS_REMAINING} openmp benchmark cases to complete."
        sleep 30
     done
}

for i in `seq 1 $NCASES`; do
arg=0$i
  if [ $i -gt 9 ]; then
    arg=$i
  fi
  base=t64${arg}
  ./makecase.sh 64 ${base}a
  ./makecase.sh 64 ${base}d
  $QFDS $base

  base=t128${arg}
  ./makecase.sh 128 ${base}a
  ./makecase.sh 128 ${base}d
  $QFDS $base
done

wait_cases_end

echo 64 1 thread, Host, 64 4 threads, Host, 128 1 thread, Host, 128 4 threads, Host>$OUTFILE
for i in `seq 1 $NCASES`; do
arg=0$i
  if [ $i -gt 9 ]; then
    arg=$i
  fi
  arga=${arg}a 
  argd=${arg}d 
  HOST1=`grep Host t64$arga.log  | awk '{print $2}'`
  HOST2=`grep Host t64$argd.log  | awk '{print $2}'`
  HOST3=`grep Host t128$arga.log | awk '{print $2}'`
  HOST4=`grep Host t128$argd.log | awk '{print $2}'`
  TIME1=`grep Time t64$arga.out  | grep Stepping | awk '{print $7}'`
  TIME2=`grep Time t64$argd.out  | grep Stepping | awk '{print $7}'`
  TIME3=`grep Time t128$arga.out | grep Stepping | awk '{print $7}'`
  TIME4=`grep Time t128$argd.out | grep Stepping | awk '{print $7}'`
  echo "$TIME1,$HOST1,$TIME2,$HOST2,$TIME3,$HOST3,$TIME4,$HOST4">>$OUTFILE
done
echo complete
