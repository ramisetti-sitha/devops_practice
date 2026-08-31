#!/bin/bash

START_TIME=$($date + %s)

echo "script executed start time is $START_TIME"

sleep 10 

END_TIME=$($date + %s)

TOTAL_TIME=$($START_TIME - $END_TIME)

echo "script executed end time is $TOTAL_TIME SEC"