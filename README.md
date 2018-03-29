# PoshWindowMT
Author: Brenton Blawat
Initial Release Date: 3/29/2018

This script will use Parent / Child Process monitoring to thread multiple PowerShell Windows. 

This is designed for applications, like PowerCLI's, that have single app domains, and will not work with PowerShell RunSpaces. It will also work well as a multi-threading solution for PowerShell scripts. (Probably less efficient than actual multi-threading & runspaces but also a solution)

BUG FIX DATE/LIST

