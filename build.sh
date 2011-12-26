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
for t in templates/*.html templates/mini/*.html
do
	echo -n "${t}... "
	if ! ./stilts/smelt/smelt "${t}"
	then
		echo "FAILED"
		exit 1
	fi
done
echo "done."

mlton -verbose 2 -codegen native -link-opt -lsqlite3 -link-opt -lcurl -link-opt -lssl -link-opt -lcrypto SFBProfiler.mlb stilts/curl/curl_supereasy.c
