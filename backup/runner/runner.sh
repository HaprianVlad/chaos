#!/usr/bin/env sh

cd experiments_to_run

sh ./deploy_code.sh

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
	
		sh ./deploy_helpers.sh
		sh ./run_chaos.sh $configFile	
		
		sh ./gather_partition_details.sh $experimentName
		if [ ${experimentName:0:1} == "B" ]; then
			sh ./gather_logs.sh $experimentName "bfs"
		else 
			sh ./gather_logs.sh $experimentName "pagerank"
		fi	
			
	fi

	cd experiments_to_run

done 

