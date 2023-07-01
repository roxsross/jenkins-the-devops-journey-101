#!/bin/bash

TRIVY_REPORT=result_trivy.json
ALLOW=2

NUM_CRITICAL=$(grep CRITICAL $TRIVY_REPORT | wc -l )
NUM_HIGH=$(grep HIGH $TRIVY_REPORT | wc -l )

echo "$NUM_CRITICAL | $NUM_HIGH"

if [ $NUM_CRITICAL -ge $ALLOW ]; then
    echo "DENY TO PRODUCTION"
    echo "TOTAL Vulnerabilities Critical: $NUM_CRITICAL"
    echo "TOTAL Vulnerabilities High: $NUM_HIGH"
    exit 1
else
    echo "ALLOW TO PRODUCTION"    
fi    