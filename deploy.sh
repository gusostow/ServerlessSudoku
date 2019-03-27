#!/bin/bash
zip -r deployments/temp.zip lambda.py

deployments_dir="deployments"
date=$(date -u +"%Y-%m-%d")
hash=$(shasum $deployments_dir/temp.zip | cut -d " " -f 1)
name="sudoku-$date-$hash.zip"
source_code_path=$deployments_dir/$name

echo "Saving source code payload to $source_code_path..."

mv $deployments_dir/temp.zip $source_code_path

cd ./terraform
terraform apply -var "source_code_path=../$source_code_path" -auto-approve