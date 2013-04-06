#!/bin/bash

TARGETS="router router-gw"

for target in $TARGETS; do
	make image TARGET=$target
done


echo Build complete
