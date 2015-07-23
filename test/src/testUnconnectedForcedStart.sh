#!/bin/bash
BIN_DIR=(BIN_DIR)
TEST_DIR=(TEST_DIR)

$BIN_DIR/write_design_problem $TEST_DIR/data/input/testUnconnectedForcedStart.edges 01 03 > testUnconnectedForcedStart.out
if [ $(diff testUnconnectedForcedStart.out $TEST_DIR/data/output/testUnconnectedForcedStart.out | wc -l | awk '{print $1}') == 0 ]; then
	echo "ERROR: Observed output does not match the expected output."
else
	echo "Test Passed!"
fi
rm testUnconnectedForcedStart.out
