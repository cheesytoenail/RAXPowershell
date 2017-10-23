function Get-LastSQLBackup () {
    param (
        # SQL Database Name
        [Parameter(Mandatory=$false)]
        [string]
        $DBName
    )
    if (!($DBName)) {
        [string]$DBName = Read-Host -Prompt "Enter name of SQL database to check"
    }
    [string]$DBName = $DBName + ","
    Get-EventLog -LogName Application | Where-Object {$_.Message -like "*$DBName*"} | Select-Object -First 1 | Format-List
}