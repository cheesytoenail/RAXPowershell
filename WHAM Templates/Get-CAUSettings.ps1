<#
    .SYNOPSIS
    CAU configuration and last run time
      
    .DESCRIPTION
    Full description: Tests for correct OS/Cluster Member/CAU Configuration, Returns configuration & if applicable last run time
    WHAM - supported: Yes
    WHAM - keywords: Patching,Patch,Cluster,CAU,Aware
    WHAM - Prerequisites: No
    WHAM - Makes changes: No
    WHAM - Column Header: GetCAUSettings
    #Option metadata below
    WHAM - Script time out (min): 1
 
    .EXAMPLE
    Full command: Get-CAUSettings
    Description: CAU configuration and last run time
      
    .OUTPUTS
    Last Run Status : Succeeded
    Time            : 05:00
    Last Run Time   : 27/09/2017 05:00:01
    Failback        : Immediate
    Week            : 5
    ErrorMsg        : -
    Day             : Wednesday
    Server          : 111111-DB1
       
    .NOTES
    Minimum OS: 2012 R2
    Minimum PoSh: 4.0
    Version Table:
    Version :: Author             :: Live Date   :: JIRA      :: QC          :: Description
    -----------------------------------------------------------------------------------------------------------
    1.0     :: Richard Weston     ::             :: IAWW-1621 ::             :: Release
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
        if (([Environment]::OSVersion.Version) -lt ([version]'6.3')) {
            $Output.ErrorMsg = "Server not compatible with CAU/Must be 2012 R2 or later"
            return $Output
        }
        #Test for cmdlet presence
        if ((Get-Command Get-Cluster -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Required Get-Cluster cmdlet not available"
            return $Output
        }
        #Test if server is a part of a cluster
        if ((Get-Cluster -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Server is not a member of a cluster"
            return $Output
        }
        #Test for cmdlet presence
        if ((Get-Command Get-CauClusterRole -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Required Get-CauClusterRole cmdlet not available"
            return $Output
        }
        #Test CAU Installed
        if ((Get-CauClusterRole -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Server has no CAU configuration"
            return $Output
        }
        #Test for cmdlet presence
        if ((Get-Command Get-CauReport -ErrorAction SilentlyContinue) -eq $null) {
            $Output.ErrorMsg = "Required Get-CauClusterRole cmdlet not available"
            return $Output
        }
        #CAU Report
        if ((Get-CauReport -ErrorAction SilentlyContinue) -eq $null) {
            $Output.'Last Run Status' = "CAU has never run"
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