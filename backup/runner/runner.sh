#!/usr/bin/env sh

#sh ./kill_chaos.sh
cd experiments_to_run
for experimentFolder in *; do
	experimentName=$experimentFolder
	if [ -d "$experimentFolder" ]; then
		cd ..
		configFile="$experimentFolder"/configFile
		helperFile="$experimentFolder"/runFile
		deployPartitionsCommand="$experimentFolder"/deploy_partitions.sh	
		
		cp $helperFile ~/helpers/run.sh
		sh ./clear.sh
		sh $deployPartitionsCommand
		#sh ./deploy_xs.sh
		#sh ./run_chaos.sh $configFile	
		sh ./gather_partition_details.sh $experimentName
		if [ ${experimentName:0:1} == "B" ]; then
			echo "DUMMY LOG" >> /media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/bfs.log	
			sh ./gather_logs.sh $experimentName "bfs"
		else 
			echo "DUMMY LOG" >> /media/ssd/hpgp-results/slipstream/_$(date +"%Y-%m-%d")/logs/pagerank.log	
			sh ./gather_logs.sh $experimentName "pagerank"
		fi	
			
	fi

done 

