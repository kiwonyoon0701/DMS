for ((i=10;i<101; i=i+10)); do
	nohup ./Create-and-Start-Task-with-argument.sh $i &
done
