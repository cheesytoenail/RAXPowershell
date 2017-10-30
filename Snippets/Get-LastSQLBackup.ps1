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
    [string]$DBName = $DBName.Trim() + ","
    try {
        $Backup = Get-EventLog -LogName Application | Where-Object {$_.Message -like "*$DBName*"} | Select-Object -First 1
    }
    catch {
        throw $_
    }
    if (!($Backup -eq $null)) {
        $Output = $Backup
    }
    if ($Backup -eq $null) {
        $Output = "No backup found for this database"
    }
    $Output
}