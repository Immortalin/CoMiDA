#!/bin/bash
BIN_DIR=(BIN_DIR)
TEST_DIR=(TEST_DIR)

$BIN_DIR/write_design_problem $TEST_DIR/data/input/testForcedStart.edges 01 03 > testForcedStart.out
if [ $(diff testForcedStart.out $TEST_DIR/data/output/testForcedStart.out | wc -l | awk '{print $1}') == 0 ]; then
	echo "ERROR: Observed output does not match the expected output."
else
	echo "Test Passed!"
fi
rm testForcedStart.out
