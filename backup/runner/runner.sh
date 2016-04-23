#!/usr/bin/env sh

#sh ./kill_chaos.sh
cd experiments_to_run
for experimentFolder in *; do
	experimentName=$experimentFolder
	if [ -d "$experimentFolder" ]; then
		cd ..
		configFile=experiments_to_run/"$experimentFolder"/configFile
		helperFile=experiments_to_run/"$experimentFolder"/runFile
		deployPartitionsCommand=experiments_to_run/"$experimentFolder"/deploy_partitions.sh	
		
		cp $helperFile ~/helpers/run.sh
		sh ./clear.sh
		sh $deployPartitionsCommand
	
		#sh ./deploy_xs.sh
		#sh ./run_chaos.sh $configFile	
		
		# dummy
		for i in `seq 137 144`; do scp stream.2.0.0  dco-node$i.dco.ethz.ch:/media/ssd/stream.2.$(($i-137)).0 ; done
	
		sh ./gather_partition_details.sh $experimentName
		if [ ${experimentName:0:1} == "B" ]; then
			sh ./gather_logs.sh $experimentName "bfs"
		else 
			sh ./gather_logs.sh $experimentName "pagerank"
		fi	
			
	fi
	cd experiments_to_run

done 

