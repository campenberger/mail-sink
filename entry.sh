#!/bin/sh

echo "Running entry point CMD: $@"
for f in entry.d/* ;
do
	echo "Executing $f"
	source $f
	cd /
done