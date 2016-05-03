#!/usr/bin/env sh

cd ~
#sh ./deploy_code.sh
cd ~/runner/experiments_to_run

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
	
		cd ~
		sh ./deploy_helpers.sh
		cd ~/runner

		sh ./run_chaos.sh $configFile	
		
		sh ./gather_partition_details.sh $experimentName
		if [ ${experimentName:0:1} -eq "B" ]; then
			sh ./gather_logs.sh $experimentName "bfs"
		else 
			sh ./gather_logs.sh $experimentName "pagerank"
		fi	
			
	fi

	cd ~/runner/experiments_to_run

done 

