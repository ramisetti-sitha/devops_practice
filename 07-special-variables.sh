#!/bin/bash

echo "all argments::$@"
echo "num of variables passed: $#"
echo "script name :$0"
echo "present directory:$PWD"
echo "who is running :$USER"
echo "home directory of root user:$HOME"
echo "PID of this script: $$"
sleeo 10 &
echo "PID of background process: $!"
echo "all args passed to script :$*"