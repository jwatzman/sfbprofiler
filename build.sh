#!/bin/sh

echo -n "squall: "
cd sql
if ! ../stilts/db/squall/squall SQL.squall
then
	echo "FAILED"
	exit 1
fi
cd ..
echo "done."

echo -n "smelt: "
cd templates
for t in *.html
do
	echo -n "${t}... "
	if ! ../stilts/smelt/smelt "${t}"
	then
		echo "FAILED"
		exit 1
	fi
done
cd ..
echo "done."

mlton -verbose 2 -codegen native -link-opt -lsqlite3 -link-opt -lcurl SFBProfiler.mlb stilts/curl/curl_supereasy.c
