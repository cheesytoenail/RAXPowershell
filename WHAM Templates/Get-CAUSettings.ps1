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
            "Server" = $ENV:ComputerName
            "Time" = "-"
            "Day" = "-"
            "Week" = "-"
            "Failback" = "-"
            "Last Run Status" = "-"
            "Last Run Time" = "-"
            "ErrorMsg" = "-"
        }
        #Test for correct version of Windows
        if (!([Environment]::OSVersion.Version) -ge (New-Object 'Version' 6,3)) {
            $Output.ErrorMsg = "Server not compatible with CAU/Must be 2012 R2 or later"
            return $Output
        }
        #Test if server is a part of a cluster
        if ((Get-Cluster -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Server is not a member of a cluster"
            return $Output
        }
        #Test CAU Installed
        if ((Get-CauClusterRole -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Server has no CAU configuration"
            return $Output
        }
        #CAU Report
        if ((Get-CauReport -ErrorAction SilentlyContinue) -eq $null) {
            $Output.LastRunStatus = "CAU has never run"
        }
        if ((Get-CauReport -ErrorAction SilentlyContinue) -ne $null) {
            $CAUReport = Get-CauReport | Select-Object -Last 1
            $Output.'Last Run Status' = $CAUReport.Status
            $Output.'Last Run Time' = $CAUReport.StartTimestamp
        }
        #Get CAU settings
        $Output.Time = (Get-CauClusterRole | Where-Object {$_.Name -like "StartDate"}).Value.ToShortTimeString().Trim()
        $Output.Day = (Get-CauClusterRole | Where-Object {$_.Name -like "DaysOfWeek"}).Value
        $Output.Week = (Get-CauClusterRole | Where-Object {$_.Name -like "WeeksOfMonth"}).Value.ToInt32($null)
        $Output.Failback = (Get-CauClusterRole | Where-Object {$_.Name -like "FailbackMode"}).Value
        #Function Output
        Return $Output
    }
    Catch
    {
        $Output = "Powershell exception :: Line# $($_.InvocationInfo.ScriptLineNumber) :: $($_.Exception.Message)"
        Return $Output
    }
}