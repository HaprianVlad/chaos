#! /bin/bash


if [ $# -eq 1 ]; then
	vr=$1
else 
	vr=0
fi

cd ~
#bash ./deploy_code.sh
cd ~/runner/experiments_to_run

for experimentFolder in *; do
	
	experimentName=$experimentFolder
	
	if [ -d "$experimentFolder" ]; then
		cd ..
		configFile=experiments_to_run/"$experimentFolder"/configFile
		helperFile=experiments_to_run/"$experimentFolder"/runFile
		deployPartitionsCommand=experiments_to_run/"$experimentFolder"/deploy_partitions.sh	
		
		cp $helperFile ~/helpers/run.sh
		bash ./clear.sh
		bash $deployPartitionsCommand

		#if [ $vr -eq 1 ]; then
		#	bash ./deploy_vertex_relabeling.sh
		#fi
	
		cd ~
		bash ./deploy_helpers.sh
		cd ~/runner

		bash ./run_chaos.sh $configFile	
		
		bash ./gather_partition_details.sh $experimentName
		if [ "$(echo $experimentName | head -c 1)" == "B" ]; then
			bash ./gather_logs.sh $experimentName "bfs"
		else 
			bash ./gather_logs.sh $experimentName "pagerank"
		fi	
			
	fi

	cd ~/runner/experiments_to_run

done 

