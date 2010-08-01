#!/bin/sh

echo -n "squall: "
cd sql
../stilts/db/squall/squall SQL.squall
cd ..
echo "done."

echo -n "smelt: "
cd templates
for t in *
do
	echo "${t}... "
	../stilts/smelt/smelt "${t}"
done
cd ..
echo "done."

mlton -verbose 2 -codegen native -link-opt -lsqlite3 SFBProfiler.mlb
