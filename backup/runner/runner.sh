#!/usr/bin/env sh

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
		sh ./deploy_xs.sh
		sh ./run_chaos.sh $configFile	
		sh ./gather_partitions_details.sh $experimentName
		if [ ${experimentName:0:1} == "B" ]; then	
			sh ./gather_logs $experimentName "bfs"
		else 
			sh ./gather_logs $experimentName "pagerank"
		fi	
			
	fi

done 

