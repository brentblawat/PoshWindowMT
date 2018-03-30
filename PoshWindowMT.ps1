<#
.SYNOPSIS
This script is an example of how to leverage PowerShell Window multi-threading.

.DESCRIPTION
This script will use Parent / Child Process monitoring to thread multiple PowerShell Windows.

This is designed for applications, like PowerCLI's, that have single app domains, and will not 
work with PowerShell RunSpaces. It will also work well as a multi-threading solution for 
PowerShell scripts. (Probably less efficient than actual multi-threading & runspaces but also a solution)

The Wiki explains this in detail: https://github.com/brentblawat/PoshWindowMT/wiki

Author: Brenton Blawat / MasteringPosh.com / @brentblawat


.NOTES
Happy Coding! Enjoy!

.#>


#Create script block
$scriptblock = { 

    # Create function that will be invoke by the second argument.
    Function start-commands ($CurrentSystem) {
        
        #########################
        #  Replace this with your code here

        #Doing something random to show the multi-threaded nature of is script
        Write-host "Current System Name: $CurrentSystem"
        write-host " "
        Start-Sleep -Seconds 10
        write-host "Closing Window Shortly...."
        # Get a random sleep time between 3 and 11 seconds. Add to $sleeptime variable.
        $sleeptime = get-random(3,4,5,6,7,8,9,10,11)
        Start-Sleep -Seconds 3
        #
        #########################

    }
}



# Fake array of systems
$AllSystems = "SRV12345", "SRV456789","SRV1456789","SRV14256789","SRV145789","SRV14656789","SRV14567789","SRV14586789","SRV14956789","SRV145006789","SRV14567819","SRV145671289","SRV145671389","SRV141556789","SRV145671689"

# Maximum Number Of Threads
$maxthreads = 5

# For This Example, Display the Parent Windows Process ID
write-host "Parent Window Process Id: $pid"

#loop through each of the systems in the $allsystems array.
foreach ($system in $AllSystems) {

    # Determine how many active child processes there are
    $activescripts = get-wmiobject win32_process | Where {$_.ParentProcessID -eq $pid} | Select Name
    
    # If the number of active processes is greater or equal to $maxthreads, wait 15 secs, reevaluate
    while ($activescripts.count -ge $maxthreads) {
        
        # Pause for 5 seconds before rechecking
        start-sleep -Seconds 15

        # Wait for Queue to Open - Query the current script Process ID ($pid) to see if any of the child scripts are still running.
        $activescripts = get-wmiobject win32_process | Where {$_.ParentProcessID -eq $pid } | Select Name
        
    }

    Start-Process PowerShell.exe -ArgumentList "-Command",$scriptblock,"start-commands('$system')"
   
}