#!/bin/bash

remove_all_users(){
    user_list=($(aws iam list-users --query 'Users[*].UserName' --output text))

    for name in "${user_list[@]}"
    do
        aws iam delete-user --user-name "$name"
    done
}

remove_all_groups(){
    group_list=($(aws iam list-groups --query 'Groups[*].GroupName' --output text))
    for group in group_list
    do
        aws iam delete-group --group-name "$group" 
    done
}

main(){
    remove_all_users
    remove_all_groups
}

main
exit 0