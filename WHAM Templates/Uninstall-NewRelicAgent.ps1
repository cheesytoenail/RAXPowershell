<#
    .SYNOPSIS
    Uninstalls the New Relic Server Monitor Agent

    .DESCRIPTION
    Full description: Uninstalls the New Relic Server Monitor Agent
    WHAM - supported: Yes
    WHAM - keywords: NewRelic,IIS,Monitoring,Windows
    WHAM - Prerequisites: Yes
    WHAM - Makes changes: Yes
    WHAM - Changes Made:
        If installed, will uninstall the New Relic Server Monitor Agent
    WHAM - Column Header: NrSMAgentStatus

    .PARAMETER Force
    Description: Force Uninstall
    Default: None

    .EXAMPLE
    Full command: Uninstall-NewRelicAgent
    Description: Uninstalls the New Relic Server Monitor Agent
    Output: AgentStatus

    .OUTPUTS
    Not Installed
    Failed
    Disabled

    .NOTES
    Minimum OS: 2008 R2
    Minimum PoSh: 3.0
    Version Table:
    Version :: Author         :: Live Date   :: JIRA      :: QC              :: Description
    -----------------------------------------------------------------------------------------------------------
    1.0     :: Richard Weston ::             :: IAWW-1706 ::                 :: Release
#>
function Uninstall-NewRelicAgent
{
    Param (
        [Parameter()][switch]$force
    )
    
    # Initalize Return Object
    $Output = New-Object PSObject -Property @{ 
            AgentStatus = "Not installed" 
    }

    try 
    {  
        #################### Supporting Functions - BEGIN ####################
        #region 

        # Check 32 and 64-bit Registry keys
        function Check-Install
        {             
            $Key32 = Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse
            $Software32 = $Key32 | ForEach-Object {Get-ItemProperty $_.pspath}
            $Key64 = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse
            $Software64 = $Key64 | ForEach-Object {Get-ItemProperty $_.pspath}
            
            $InstalledSoftware = $Software32 + $Software64 | Where-Object {$_.DisplayName -like "*New Relic Server Monitor*"}
            return $InstalledSoftware
        }

        #endregion 
        ##################### Supporting Functions - END #####################         
        
        # Prompt User about changes
        if (-not $Force) 
        {
            if ((Read-Host "Warning: This will uninstall the New Relic Server Monitor Agent. Enter Y to continue") -notlike "Y*") 
            {
                Exit
            }
        }
                
        # Check if New Relic Agent is installed
        try 
        {
            # Do not proceed if New Relic Agent is not installed first
            if (-Not (Check-Install))
            {
                $Output.AgentStatus = "ERROR: Server Monitor Agent not installed"
                return $Output;
            }
        }
        catch 
        {
            $Output.AgentStatus = "ERROR: Could not verify if Server Monitor Agent is already installed"
            return $Output
        }

        # Run MSIExec to uninstall agent
        try 
        {
            #Check reg for uninstall
            $Uninstall = Check-Install

            #Get the uninstall GUID using regex
            $Regex =  "\{(.*?)\}"
            $UninstallGUID = ([regex]::matches($($Uninstall.UninstallString), $Regex) | Select-Object Value).Value
            
            #Generate the MSI params            
            $Params = @(
                "/X $UninstallGUID"
                "/qn"
                "REBOOT=SUPPRESS"
                "/L*v C:\rs-pkgs\WHAM\Uninstall_NewRelicSM_Log.txt"
            )
            
            # Uninstall New Relic using MSI GUID
            try 
            {
                Start-Process msiexec -ArgumentList $Params -Wait -ErrorAction Stop
            }   
            catch 
            {
                $Output.AgentStatus = "ERROR: Could not uninstall agent using GUID"
            }
        }
        catch 
        {
            $Output.AgentStatus = "ERROR: Could not be uninstalled"
        }
        
        # Check the status of Plugin
        if ($installedSoftware = Check-Install)
        {
            $Output.AgentStatus = "ERROR: Failed to uninstall"
        }
        else 
        {
            $Output.AgentStatus = "SUCCESS: Uninstalled"
        }

        # Return the status of agent uninstallation
        return $Output
    }
    catch 
    {
        $Output.AgentStatus = "ERROR : Unhandled exception :: (Line: $($_.InvocationInfo.ScriptLineNumber) Line: $($_.InvocationInfo.Line) Error message: $($_.exception.message))"
        return $Output
    }
}