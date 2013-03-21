##########################################################
# checkNetwork.ps1
# script script checks netwrok with ping 
#
# Pre-Requisites: 
#
# Usage syntax:
# 
#
# Last Modified: 2013-03-18
#
# Version: 0.1
#
# Version History:
# 	0.1
# 	- initial version
#   0.2
#   - Powershell V2 compatibility
#
# Created by: gerhard.berthold@coi.de
#
########################################################## 

function Start-NetworkCheck {
################################################################
<# 
.Synopsis
    Starts an network check with ping.
.Description
    checks if the server with the given ip is reachable
    the script uses the ping command, it reports only to log file by failure
    be careful it's an infinite loop!

    use get-help Start-NetworkCheck
.Parameter ip
    the server ip address to check
.Parameter logfile
    the logfile to report ping failure
.Example
    Start-NetworkCheck 127.0.0.1 checklocalesystem.log
.Example
    Start-NetworkCheck -ip 8.8.8.8 -logfile checkgoogledns.log
.Example
    Start-NetworkCheck -ip 8.8.8.8 -logfile C:\temp\checkgoogledns.log
.Link
    http://www.coi.de
#>
################################################################
    param(
        [Parameter(Mandatory = $true,
            Position = 0,
            HelpMessage="Enter a valid ip address. See help for this script for further information (get-help Start-NetworkCheck)"
        )]
        [string] $ip,
        
        [Parameter(Mandatory = $false,
            Position = 1
        )]
        [string] $logfile = "pingfailure.txt"
    )
   
    [int] $cnt = 1;
    
    if($ip -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}")
    {
        Write-Host "to stop just press Ctrl+C!" -ForegroundColor Yellow -BackgroundColor Red
        for (;;sleep 2) {
            ping -n 1 $ip > $null;
            # handle ping failure
            if( -not $?) {
                get-date -f s | tee-object -Variable tee 
                out-file  $logfile -InputObject $tee -Append 
                Write-Host -NoNewLine "$cnt | "
            }
            $cnt++
        }
    } else {
        Write-Error -Message "format of ip address:'$ip' is invalid" -Category 'InvalidArgument' -RecommendedAction "use an valid ip address format like 8.8.8.8" 
    }
}