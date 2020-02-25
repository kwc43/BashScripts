#!/bin/bash

################################################# Get Repository ########################################################################

function Get_Repository {
    while true; do
        read -p "Enter repository name : " repositoryName
        if Found_Repository_Depth_1; then
            path=$(dirname "${repositoryName}")
            cd $path/$repositoryName
            break;
        fi
    done  
}

function Found_Repository_Depth_1 {
    if [ -d $repositoryName ]; then
        echo -e "Repository found... \n"
        return 0 
    else 
        echo -e "Repository not found, try again \n " 
        return 1
    fi
}

################################################# Update Local Repository ##################################################################

function Update_Local_Repository {
    git checkout master
    git fetch
    git remote prune origin
}

################################################# Filter Branches #########################################################################

function Get_Threshold {
    while true; do
        read -p  "Enter the amount of months from 1-3 : " age 
        case "$age" in 
            [1-9] | 1[0-2] ) echo -e "Deleting branches that have not received commits/updates in the past $age months... \n" 
            break ;;
            * ) ;; 
         esac 
    done
}

function Delete_All_Branches {
    while true; do
        read -p "Delete all branches in threshold regardless of merged or unmerged? [Y/N] " yn
        case "$yn" in
            [yY] ) 
                return 0
                break ;;
            [nN] ) 
                return 1
                break ;;
            * ) ;;
        esac
    done
}

function Delete_Only_Merged_Or_Unmerged_Branches {
    while true; do
        read -p "Delete only merged branches (Answering N, will delete only unmerged branches)? [Y/N] " yn
        case "$yn" in
            [yY] ) 
                branchFilter="--merged"
                break ;;
            [nN] ) 
                branchFilter="--unmerged"
                break ;;
            * ) ;;
        esac
    done
}

function Filter_Branches {
    Get_Threshold
    if Delete_All_Branches; then
        branchFilter=""
    else
        Delete_Only_Merged_Or_Unmerged_Branches
    fi
}

################################################# Delete Branches #########################################################################

function Delete_Branches {
    now=`date +%F`
    dateThreshold=$(date -d "$now-$age months" +%F);

    for branch in $(git branch -r $branchFilter | grep -v HEAD); do
        branchAge=$(date -d "$(git show --format="%cd" $branch --date=short | head -n 1)" +%F);
        if [[ $branchAge < $dateThreshold ]]; then
            echo -e "Latest Commit : $branchAge" \n "Branch Name : " $branch|sed 's/ *origin\///';
            $branch|sed 's/ *origin\///'| xargs -I {} git push origin :{} 
        fi
    done
}

######################################################### Main ###########################################################################

function Run_Script {
    cd C:\git 
    Get_Repository
    Update_Local_Repository
    Filter_Branches
    Delete_Branches

    echo "Done"
}

######################################################################################################################################

Run_Script