#!/bin/sh

cat sql/newdb.sql | sqlite3 sfbprofiler.sqlite
