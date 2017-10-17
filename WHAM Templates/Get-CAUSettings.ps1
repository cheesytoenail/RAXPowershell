<#
    .SYNOPSIS
    <Basic Function Example, with single PSO output. Brief description of what script does. max 72 characters>
      
    .DESCRIPTION
    Full description: <Detailed description of what script does>
    WHAM - supported: Yes
    WHAM - keywords: XXXXX,XXXXX,XXXXX,XXXXX
    WHAM - Prerequisites: Yes/No
    WHAM - Makes changes: No
    WHAM - Column Header: <Column Header to be displayed in output>
    #Option metadata below
    WHAM - Script time out (min): 1
    WHAM - Download File: ExampleZip.zip
    WHAM - Get IPs from CORE: Yes (Remove if No)
    WHAM - Isolate: Yes (Remove if No)
    WHAM - Used By: Name of other WHAM script that uses this function
    WHAM - TSQL: Yes (Remove if No)
 
    .EXAMPLE
    Full command: <example command>
    Description: <description of what the command does>
    Output: <List output>
      
    .OUTPUTS
    <List outputs>
       
    .NOTES
    Minimum OS: 2008 R2
    Minimum PoSh: 2.0
    Version Table:
    Version :: Author             :: Live Date   :: JIRA     :: QC          :: Description
    -----------------------------------------------------------------------------------------------------------
    1.0     :: Powell Shellington :: 01-JAN-2001 :: IAWW-111 :: Joe Bloggs  :: Release
#>
Function Get-CAUSettings
{
    Try
    {
        #Create output object
        $Output = New-Object PSObject -Property @{
            Server = $ENV:ComputerName
            OutputItem1 = "-"
            OutputItem2 = "-"
        }
        #Test for correct version of Windows
        if (!([Environment]::OSVersion.Version) -ge (New-Object 'Version' 6,3)) {
            $Output = "Server not compatible with CAU"
        }
        #Test if server is a part of a cluster
        if ((Get-Cluster -ErrorAction SilentlyContinue) -eq $null) {
            $Output = "Server is not a member of a cluster"
        }
        #Test CAU Installed
        if ((Get-CauClusterRole -ErrorAction SilentlyContinue) -eq $null) {
            $Output = "Server has no CAU configuration"
        }
        #Get CAU settings
        $Output.Time = (Get-CauClusterRole | Where-Object {$_.Name -like "StartDate"}).Value.ToShortTimeString().Trim()
        $Output.Day = (Get-CauClusterRole | Where-Object {$_.Name -like "DaysOfWeek"}).Value.Trim()
        $Output.Week = (Get-CauClusterRole | Where-Object {$_.Name -like "WeeksOfMonth"}).Value.Trim()
        $Output.Failback = (Get-CauClusterRole | Where-Object {$_.Name -like "FailbackMode"}).Value.Trim()
        
        Return $Output
    }
    Catch
    {
        $Output.OutputItem1 = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Return $Output
    }
}