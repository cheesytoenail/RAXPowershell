function Test-Credentials {
    ## Clears the $Error variable for test
    $Error.Clear()
    ## Run test
    try {
        Start-Process -FilePath cmd.exe /c -Credential (Get-Credential -Credential $null)
    }
    catch {
        throw $_
    }
    ## Checks $Error if clear
    if (!$Error) {
        Write-Host -ForegroundColor Green "Credential Success"
    }
    if ($Error) {
        Write-Host -ForegroundColor Red "Credential Failed"
    }
}