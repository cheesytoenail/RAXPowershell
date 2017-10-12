function Update-VMWareTools {
    $Path = 'C:\rs-pkgs'
    $Ticket = Read-Host -Prompt 'Enter Ticket Number'
    $URL = 'https://packages.vmware.com/tools/esx/latest/windows/x64'
    $VMWareTools = (Invoke-WebRequest -Uri "https://packages.vmware.com/tools/esx/latest/windows/x64/index.html").links.href | Where-Object {$_ -like "*.exe"}
    $Arguments = @(
        "/S",
        "/v `"/qn /l*v $Path\$Ticket\Install.log  ADDLOCAL=ALL REMOVE=VMCI reboot=r`""
    )
    try {
        $Ticket
        if (!(Test-Path -Path "$Path\$Ticket")) {
            New-Item -Path "$Path\$Ticket" -ItemType Directory
        }
        Start-BitsTransfer -Source "$URL/$VMWareTools" -Destination "$Path\$Ticket\$VMWareTools"
        Start-Process -FilePath "$Path\$Ticket\$VMWareTools" -ArgumentList $Arguments | Out-Null
        while (!(Get-Content -Path "$Path\$Ticket\Install.log" -tail 5 | Where-Object {$_ -like "*Verbose logging stopped*"})) {
            Start-Sleep -Seconds 1
            $Timer++
            if ($Timer -eq 300) {
                Write-Output "Installer Timed Out After 5mins"
                break
            }
        Get-Content -Path .\Install.log | Where-Object {$_ -like "*Product: VMware Tools*"}
        }
    }
    catch {
        throw $_
    }
}