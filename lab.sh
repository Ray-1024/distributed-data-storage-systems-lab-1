#!/bin/bash

psql -h pg -d studs -f ~/lab.sql 2>&1 | sed 's|.*NOTICE:  ||g'