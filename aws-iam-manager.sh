#!/bin/bash

# AWS IAM Manager Script for CloudOps Solutions
# This script automates the creation of IAM users, groups, and permissions


# Define IAM User Names Array
IAM_USER_NAMES=("alice" "bob" "charlie")

# Function to create IAM users
create_iam_users() { echo "Starting IAM user creation process... "
echo "-------------------------------------"

# Get a list of all preexisting users to avoid duplicates.
user_list=($(aws iam list-users --query 'Users[*].UserName' --output text))

# Write the loop to create the IAM users here---"n 
for name in "${IAM_USER_NAMES[@]}"
  do
    # check if the user exist before creation
    if [[ " ${user_list[@]} " =~ " ${name} " ]]; then
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

  # check existing group list
  group_list=($(aws iam list-groups --query 'Groups[*].GroupName' --output text))

   echo "Creating admin group and attaching policy..."    
   echo "--------------------------------------------" 
   group_name="admin"       
   # Check if group already exists 
    if [[ " ${group_list[@]} " =~ " ${group_name} " ]]; then
      echo "Success: AdministratorAccess policy attached"  
    else
      echo "---Write this part to create the admin group---"
      aws iam create-group --group-name "$group_name"

       # Attach AdministratorAccess policy  
      echo " Attaching AdministratorAccess policy... "
      aws iam attach-group-policy --group-name "$group_name" --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
    fi 
   
  
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
