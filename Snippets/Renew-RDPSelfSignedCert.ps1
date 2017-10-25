function Renew-RDPSelfSignedCert () {
    $Now = Get-Date
    $Certificates = Get-ChildItem 'Cert:\LocalMachine\Remote Desktop\*'
    foreach ($Certificate in $Certificates) {
        if ($Certificate.NotAfter -lt $Now) {
            Write-Host "$Certificate.SubjectName.Name Removed" -foregroundcolor Red
            Remove-Item $Certificate -Force | Out-Null
        }
        if ($Certificate.NotAfter -gt $Now) {
            Write-Host "$Certificate.SubjectName.Name has not yet expired" -ForegroundColor Green
            Write-Host "$Certificate.SubjectName.Name expires $Certificate.NotAfter" -ForegroundColor Green
        }
        if ($Certificate.NotAfter -lt $Now) {
            Restart-Service -DisplayName 'Remote Desktop Configuration' -Force | Out-Null
            Write-Host "Remote Desktop Configuration Service has been restarted"
        }
    }
}