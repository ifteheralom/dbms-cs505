#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <db_username> <db_password>"
    exit 1
fi

# Total number of queries
TOTAL_QUERIES=1

# Set the Derby environment variable
export DERBY_HOME="/home/ial261/dbms-cs505/derby"

# Database connection details
DB_NAME="tpch"
DB_USER="$1"
DB_HOST="localhost"
DB_PORT="1527"
DB_PASS="$2"

QUERY_DIR="queries"
RESULTS_DIR="results"

# Reset total execution time
TOTAL_EXEC_TIME=0

# Start monitoring CPU and memory usage, redirect output to a file
vmstat 1 > vmstat_output.txt &
VMSTAT_PID=$!

# Start monitoring disk I/O, redirect output to a file
iostat 1 > iostat_output.txt &
IOSTAT_PID=$!

# Start monitoring overall resource utilization, redirect output to a file
sar -u -r -d 1 > sar_output.txt &
SAR_PID=$!

# Check if results directory exists, if not, create it
if [ ! -d "$RESULTS_DIR" ]; then
  mkdir -p "$RESULTS_DIR"
fi

# Check if query directory exists, if not, create it
if [ ! -d "$QUERY_DIR" ]; then
  mkdir -p "$QUERY_DIR"
fi

for ((i=1; i<=TOTAL_QUERIES; i++)); do
    sql_file="queries/$i.sql"
    
    # Check if the SQL file exists
    if [ ! -f "$sql_file" ]; then
        echo "Error: SQL file '$sql_file' not found."
        continue
    fi

    # Capture start time
    START_TIME=$(date +%s.%N)
    
    # Execute each SQL query in the file using ij tool
    echo "Executing SQL queries from $sql_file..."
    $DERBY_HOME/bin/ij << EOF
CONNECT 'jdbc:derby://$DB_HOST:$DB_PORT/$DB_NAME;user=$DB_USER;password=$DB_PASS';
SET schema DBMS;
RUN '$sql_file';
EXIT;
EOF

    # Capture end time
    END_TIME=$(date +%s.%N)
    # Calculate execution time
    EXEC_TIME=$(echo "$END_TIME - $START_TIME" | bc)
    # Add execution time to total
    TOTAL_EXEC_TIME=$(echo "$TOTAL_EXEC_TIME + $EXEC_TIME" | bc)
    # Log execution time in the results folder
    echo "Query $i execution time: $EXEC_TIME seconds" >> "$RESULTS_DIR/query_times.log"
done

# Kill the monitoring processes
kill $VMSTAT_PID
kill $IOSTAT_PID
kill $SAR_PID

# Log total execution time
echo "Total execution time: $TOTAL_EXEC_TIME seconds" >> "$RESULTS_DIR/query_times.log"

# Calculate throughput
THROUGHPUT=$(echo "scale=2; $TOTAL_QUERIES / $TOTAL_EXEC_TIME" | bc)
FILENAME="query_times_$(date +"%Y%m%d%H%M%S")"
echo "Throughput: $THROUGHPUT queries per second" >> "$RESULTS_DIR/$FILENAME.log"

echo "All queries executed. Check $RESULTS_DIR/$FILENAME.log for execution times."
