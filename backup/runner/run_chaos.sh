#! /bin/bash

export LD_LIBRARY_PATH="/usr/local/lib/:$LD_LIBRARY_PATH"

# Utility functions
fail () {
	echo "Failure encountered! Exiting!"
	exit -1
}

e () {
	echo -e '\E[37;44m'"\033[1m$1\033[0m" 
}

if [ $# -ne 1 ]; then
echo "Usage: run_slipstream.sh <config file>"
echo "Please specify a configuration file!"
fail
fi

 . ./$1

if [ -z $ROOT_DIR ]; then
echo "Missing configuration!"
fail
fi

# Benchmark run
for m in $MEMORIES; do
for input in $INPUTS; do
for i in $NUM_MACHINES; do
names=""
ports=""
ifaces=""

for (( j=0; j<$i; j++ )); do
names="${names}name$j=${MACHINE[$j]}-10g
"
ports="${ports}base_port$j=5555
"
ifaces="${ifaces}iface$j=p1p1
"
done
for (( j=0; j<$i; j++ )); do
ssh $USER@${MACHINE[$j]} "echo $j > $ROOT_DIR/id"
ssh $USER@${MACHINE[$j]} "cat << EOF > $ROOT_DIR/slipstore.ini
[machines]
count=$i
me=$j
${names}${ifaces}
EOF"
ssh $USER@${MACHINE[$j]} "cat << EOF > $ROOT_DIR/global.sh
ROOT_DIR=${ROOT_DIR}
RESULTS_FOLDER=${RESULTS_FOLDER}
BLOCKED_MEMORY=${BLOCKED_MEMORY}
EOF"
done

if [[ "$input" == rmat* ]]; then
scale=$(echo "$input" | sed -E "s/[^0-9]+([0-9]+)/\1/")
name=rmat-${scale}_s${i}
e "Generating graph $name..."
clush -w ${GROUP[$i]} -l $USER "$SUDO $ROOT_DIR/helpers/gen.sh $ROOT_DIR $name $scale $i $GEN_TYPE"
elif [[ "$input" == fixed* ]]; then
name=$input
else
name="${input}_s${i}"
fi;
sleep 10

if [ $VR -eq 1 ]; then
	relabeled="relabelled"
	if [ $GEN_TYPE == "directed" ]; then
		n=rmat-${scale}_s${i}ls 	
	else
		n=rmat-${scale}-und_s${i}
	fi
	e "Rellabeling graph $n..."
	clush -w ${GROUP[$i]} "pypy /media/ssd/vertex_relabeling.py /media/ssd/$n ${scale} /media/ssd/$relabeled"
	clush -w ${GROUP[$i]} "rm /media/ssd/$n"
	clush -w ${GROUP[$i]} "mv /media/ssd/$relabeled /media/ssd/$n "
	sleep 10 
fi


e "Running on ${GROUP[$i]}"

for j in $CORES; do
for additional in $ADDITIONALS; do
for alg in $ALGS; do
for k in $KS; do

e "Killing all processes..."
clush -w ${GROUP[$i]} -l $USER "$SUDO $ROOT_DIR/helpers/killall.sh $i"
sleep 30

e "Running $alg on $name with n=$i, ncpus=$j, mem=$m"
clush -w ${GROUP[$i]} -l $USER "$SUDO $ROOT_DIR/helpers/run.sh $ROOT_DIR $alg $name $i $j $m $k $additional"

#clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/stream*"
clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/chkp* && $SUDO rm -f $ROOT_DIR/snap*"
done
done
done
done

if [[ "$input" == rmat* ]]; then
echo ""
clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/rmat-*"
fi;

clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/id && $SUDO rm -f $ROOT_DIR/slipstore.ini && $SUDO rm -f $ROOT_DIR/global.sh"
#clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/stream*"
clush -w ${GROUP[$i]} -l $USER "$SUDO rm -f $ROOT_DIR/chkp* && $SUDO rm -f $ROOT_DIR/snap*"
done
done
done

e "Benchmarks done!"

