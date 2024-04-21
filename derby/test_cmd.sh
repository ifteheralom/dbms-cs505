#!/bin/bash

# Check if a filename is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <sql_file>"
    exit 1
fi

# Store the SQL file name provided as an argument
sql_file="$1"

# Check if the SQL file exists
if [ ! -f "$sql_file" ]; then
    echo "Error: SQL file '$sql_file' not found."
    exit 1
fi

# Set the Derby environment variable
export DERBY_HOME="/home/vcsso/derby"  # Set this to your Derby installation directory

# Execute each SQL query in the file using ij tool
echo "Executing SQL queries from $sql_file..."
$DERBY_HOME/bin/ij << EOF
CONNECT 'jdbc:derby://localhost:1527/tpch;user=root;password=33333';
SET schema DBMS;
RUN '$sql_file';
EXIT;
EOF

# Check if the execution was successful
if [ $? -eq 0 ]; then
    echo "SQL queries executed successfully."
else
    echo "Error executing SQL queries."
fi
