#!/bin/bash

# AWS IAM Manager Script for CloudOps Solutions
# This script automates the creation of IAM users, groups, and permissions


# Define IAM User Names Array
IAM_USER_NAMES=("alice" "bob" "charlie")

# Function to create IAM users
create_iam_users() { echo "Starting IAM user creation process... "
echo "-------------------------------------"
# Write the loop to create the IAM users here---"n 
for name in "${IAM_USER_NAMES[@]}"
  do
    if aws iam get-user --user-name "$name" >/dev/null 2>&1; then
      echo "User $name already exists. Skipping creation."
    else
      # create password
      password="${name}Company@1234"
      # Create user
      aws iam create-user --user-name "$name" 
      aws iam create-login-profile --user-name "$name" --password "$password" --password-reset-required
      echo "username: $name ------------------ Pass: $password" >> company_credentials.txt
    fi
  done

echo "------------------------------------"
echo "IAM user creation process completed."
     
}


# Function to create admin group and attach policy
create_admin_group() {
   echo "Creating admin group and attaching policy..."    
   echo "--------------------------------------------"        
   # Check if group already exists

  aws iam get-group --group-name "admin" >/dev/null 2>&1    
  if [ $? -eq 0 ]; then 
    echo "Success: AdministratorAccess policy attached"  
  else
    echo "---Write this part to create the admin group---"
    aws iam create-group --group-name admin 

    echo " Attaching AdministratorAccess policy... "
    aws iam attach-group-policy --group-name admin --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
  fi 
  # Attach AdministratorAccess policy  
  echo "---Write the AWS CLI command to attach the policy here---"
  echo "----------------------------------"  
 
  }

# Function to add users to admin group
add_users_to_admin_group() {
  echo "Adding users to admin group..." 
  echo "------------------------------"  
  echo "---Write the loop to handle users addition to the admin group here---"  
  echo "----------------------------------------" 
  echo "User group assignment process completed."
  for name in "${IAM_USER_NAMES[@]}"
  do
    aws iam add-user-to-group --user-name "$name" --group-name admin
  done
  }

# Main execution function
main() {
   echo "==================================" 
   echo " AWS IAM Management Script" 
   echo "==================================" 
   echo ""  
   # Verify AWS CLI is installed and configured 
   if ! command -v aws &> /dev/null; then     
   echo "Error: AWS CLI is not installed. Please install and configure it first."     
   exit 1 
   fi 

   # Create file for credentials if not in existence 
   if  [ ! -e company_credentials.txt ]; then
  touch company_credentials.txt
  fi
   # Execute the functions 

   create_iam_users 
   create_admin_group 
   add_users_to_admin_group  

   echo "==================================" 
   echo " AWS IAM Management Completed" 
   echo "=================================="

   }

# Execute main function
main

exit 0
