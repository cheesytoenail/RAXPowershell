########################################
#Uncoment line below for debugging.
#$DebugPreference = "Inquire"
#$VerbosePreference = "Continue"

#Author/s: Martin Howlett & Mark Wichall
#$Global:MenuAuthor = "" #uncomment and enter author name if you want it to show on menu title.

#Create: 15/12/2014
#Last Updated: 05/01/2015
#Notes: Nucleus Exstention Module.  Calls all the .ps1 files related to different Nucleus exstentions.
#Version: 0.6
#$Global:MenuVersion = "Version 0.6" #uncomment and enter version number if you want it to show on menu title.

#Uncoment lines below for debugging.
#$DebugPreference = "Inquire"
#$VerbosePreference = "Continue"

#Menu title.
$Global:MenuTitle = @"                                     
                      __   ___  __       ___  __   __      __   __   __     __  ___  __     
|  /\  |  |    __    |  \ |__  /__  |__/  |  /  \ |__)    /__  /    |__) | |__)  |  /__     
| /~~\ |/\|          |__/ |___ .__/ |  \  |  \__/ |       .__/ \__, |  \ | |     |  .__/                                         

 Wiki: https://one.rackspace.com/display/IAW/                                       

  For Ticket  = $Global:ticketnum
  For Account = $Global:accountnum
"@
#Good link for creating ascii text.
#http://patorjk.com/software/taag/#p=display&f=Graffiti&t=Type%20Something
#remove any ` from title instead use ' symbols.

#Colour of menu title e.g. green (Default)
$Global:MenuTitleColour = "Green"

#Menu Description text
$Global:MenuDescription = @"                                     
List of Nucleus Extensions.  New extensions will be automatically added to the menu.                                        
"@

#Colour of Menu Description text e.g. white (default)
$Global:MenuDescriptionColour = "White"

#Menu sort order values = Synopsis (Default), Name
$Global:MenuSortOrder = "Synopsis"

#Menu item display. With $true (default) it only shows the help synopsis, with $false is shows function name.
$Global:SynopsisOnly = $True

#It runs a clear host after import of module, if false no clear host run.  Helps debug errors at start of script e.g. import module.
$Global:ClearMenu = $False
#Changed to false for debugging - 24/12/2014

#Close window on menu exit.
$Global:ExitOnQuit = $True

#Set to true if you want to copy the code to invoke the functions into this module and customise it.  
#Forexample change it to run target function then send it's output somewhere else. Run function, return an output and send to BBcode converter.
#Copy the invoke-function from dynamicmenu module into this module and rename it to Invoke-CustomFunction then set this var to True.
$Global:InvokeCustomFunction = $False

############# Invoke-CustomFunction - BEGIN #############
#Add <Invoke-CustomFunction> here if used 
############# Invoke-CustomFunction - END #############

########################################

<#
#Run Example:
Run via Nucleus.
-executionpolicy bypass -noexit -Command "& {$Drive="Y:";If(Test-Path $Drive){$Mod="NucleusExst";$Global:session="$session";$Global:ticketnum="$ticketnum";CD $Drive\DynamicMenu;import-module ".\DynamicMenu.psm1";Start-ModuleMenu -N "NucleusExst" -P ".\NucleusExst.psm1"}ELSE{Write-Host "Error Check Drive Mapping for \\media10.lon.rackspace.com\UploadBuffer\Powershell\ path not found" -ForegroundColor Red}}"
#>

############# Menu Functions (Menu-*, MenuNew-* or MenuDisable-*) - BEGIN #############

<#
.Synopsis
   Send Ticket to - Business Development Consultant
.DESCRIPTION
   More detailed explanation of function. - edit as required.   
#>
Function Menu-SendTktBDC{

Write-Host "`nSending Ticket to BDC`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Send-TktFollowupEmail.ps1 -session $Global:session -ticketnum $Global:ticketnum -BDCSwitch"
invoke-expression -command $commands 
}

<#
.Synopsis
   Send Ticket to - Lead Engineer
.DESCRIPTION
   More detailed explanation of function. - edit as required.   
#>
Function Menu-SendTktLT{

Write-Host "`nSending ticket to Lead Tech`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Send-TktFollowupEmail.ps1 -session $Global:session -ticketnum $Global:ticketnum -LTSwitch"
invoke-expression -command $commands
}

<#
.Synopsis
   Send Ticket to - Account Manager
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-SendTkkAM{

Write-Host "`nSending ticket to account manager.`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Send-TktFollowupEmail.ps1 -session $Global:session -ticketnum $Global:ticketnum -AMSwitch"
invoke-expression -command $commands
}

<#
.Synopsis
   Assign Devices - from Load Balancer
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-AssignDevicesfromLoadBalancer{

Write-Host "`nAssiging Load Balanced Servers to the Ticket.`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Assign_Devices_from_Load_Balancer.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands
}

<#
.Synopsis
   Add Ticket Reminder
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-TicketReminder{

Write-Host "`nSetting a ticket reminder.`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Ticket_Reminder.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands
}

<#
.Synopsis
   Assign Devices - from Cluster Object
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-AssignDevicesforClusterObject{

Write-Host "`nAssigning Devices for Cluster Object.`n"

$commands = "$Global:RootPath\Nucleus_Extensions\Assign_Devices_from_Cluster_Object.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands
}

<#
.Synopsis
   Maintenance Generator (MaGe)
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-GenerateMaintenance{

Write-Host "`nMaintenance Generator (MaGe)`n"

$commands = "$Global:RootPath\Maintenance_Generator\Maintenance_Generator.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands
}

<#
.Synopsis
   BBcode - Convert CSV file to BBCode.
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-CSVtoBBCode{
$commands = "import-module $Global:RootPath\BBCode\bbcode.psm1; Convertto-BBCode -CSVin -Clip -OutputMessage -NoReturn -Preview -NoLoop"
invoke-expression -command $commands
}

<#
.Synopsis
   CTKCore - List of all devices from the account. Selectively output to csv file.
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-AccountListofDevices{
#Check Version of Powershell, only run on version 3 and above.
$PSVer = $psversiontable.psversion.major
If ($PSVer -lt 3)
{
    Write-Host "Powershell version $PSVer installed.  Powershell 3.0 reqiured for Out-GridView. Exiting script." -forgroundcolor Red
    Break
}

Write-Host "`nListing all devices for the Account. Select devices to output to CSV.`n"

Write-Host "`nDepending on the number of devices on the account it may take sometime to query core...`n"

Try
{
    Import-Module "$Global:RootPath\Shared_Modules\Logging_Module.psm1" -EA SilentlyContinue
    Write-MasterLogFile -functionname "CTKcore" -scriptname "ExportAccountDevicesCSV" -Notes "" -Account "" -Path "$Global:RootPath"
}
Catch
{
    #Do nothing
}

$commands = "import-module $Global:RootPath\CTKCore\CTKCore.psm1 -DisableNameChecking; Get-CoreDevices -account $Global:accountnum -NoOutput -NoDRAC;" 
$devices = invoke-expression -command $commands
If ($devices) 
{
    $deviceList = $Devices | Select-Object Status, Name, ServerName, Nickname, Datacenter, OStype, OSName, PlatType, PlatName, IP, PrivateIP, BackupIP, dracnet_ip, vCenter, Offline, Account, Number, date_online | Sort-Object Status | Out-GridView -Title "All devices for Account, select devices to export to csv.  Then click Ok" -PassThru
    
    If ($deviceList) 
    {
        $tempFile = [io.path]::GetTempFileName() | Rename-Item -NewName { $_ -replace 'tmp$', 'csv' } �PassThru
        $devicelist | export-csv -Path $tempFile -NoTypeInformation;
        
        Write-host "`n`nCsv file has been generated here:" -ForegroundColor Green
        Write-host "$tempFile"
        Write-Host " "
    }
    Else
    {
    Write-Host "No selection made! Exiting."
    }
}
Else
{
    Write-Host "Error - No Devices returned from account" -ForegroundColor Red
}
}

<#
.Synopsis
   CTKCore - List of all devices from the ticket. Selectively output to csv file.
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-TicketListofDevices{
#Check Version of Powershell, only run on version 3 and above.
$PSVer = $psversiontable.psversion.major
If ($PSVer -lt 3)
{
    Write-Host "Powershell version $PSVer installed.  Powershell 3.0 reqiured for Out-GridView. Exiting script." -forgroundcolor Red
    Break
}

Write-Host "`nListing all devices assigned to the ticket.  Select devices to output to CSV.`n"

Write-Host "`nDepending on the number of devices on the account it may take sometime to query core...`n"

Try
{
    Import-Module "$Global:RootPath\Shared_Modules\Logging_Module.psm1" -EA SilentlyContinue
    Write-MasterLogFile -functionname "CTKcore" -scriptname "ExportTicketDevicesCSV" -Notes "" -Account "" -Path "$Global:RootPath"
}
Catch
{
    #Do nothing
}


$commands = "import-module $Global:RootPath\CTKCore\CTKCore.psm1 -DisableNameChecking; Get-CoreDevices -ticket $Global:ticketnum -NoDRAC;"
$Devices = invoke-expression -command $commands
If ($devices) 
{
    $deviceList = $Devices | Select-Object Status, Name, ServerName, Nickname, Datacenter, OStype, OSName, PlatType, PlatName, IP, PrivateIP, BackupIP, dracnet_ip, vCenter, Offline, Account, Number, date_online | Sort-Object Status | Out-GridView -Title "All devices for Account, select devices to export to csv.  Then click Ok" -PassThru
    
    If ($deviceList) 
    {
        $tempFile = [io.path]::GetTempFileName() | Rename-Item -NewName { $_ -replace 'tmp$', 'csv' } �PassThru
        $devicelist | export-csv -Path $tempFile -NoTypeInformation;
        
        Write-host "`n`nCsv file has been generated here:" -ForegroundColor Green
        Write-host "$tempFile"
        Write-Host " "
    }
    Else
    {
    Write-Host "No selection made! Exiting."
    }
}
Else
{
    Write-Host "Error - No Devices returned from account" -ForegroundColor Red
}
}

<#
.Synopsis
   CTKCore - Select additional devices to add to ticket.
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-TicketAddAdditionalDevices{
#Check Version of Powershell, only run on version 3 and above.
$PSVer = $psversiontable.psversion.major
If ($PSVer -lt 3)
{
    Write-Host "Powershell version $PSVer installed.  Powershell 3.0 reqiured for Out-GridView. Exiting script." -forgroundcolor Red
    Break
}

Write-Host "`nListing all devices on the account select devices to add to ticket.`n"

Write-Host "`nDepending on the number of devices on the account it may take sometime to query core...`n"

Try
{
    Import-Module "$Global:RootPath\Shared_Modules\Logging_Module.psm1" -EA SilentlyContinue
    Write-MasterLogFile -functionname "CTKcore" -scriptname "AddDevicesToTicket" -Notes "" -Account "" -Path "$Global:RootPath"
}
Catch
{
    #Do nothing
}

$commands = "import-module $Global:RootPath\CTKCore\CTKCore.psm1 -DisableNameChecking; Get-CoreDevices $Global:accountnum -NoOutput -NoDRAC;" 
$Devices = invoke-expression -command $commands
If ($devices) 
{
    $deviceList = $Devices | Select-Object Status, Name, ServerName, Nickname, Datacenter, OStype, OSName, PlatType, PlatName, IP, PrivateIP, BackupIP, dracnet_ip, vCenter, Offline, Account, Number, date_online | Sort-Object Status | Out-GridView -Title "All devices for Account, select devices to add to ticket.  Then click Ok " -PassThru
    
    Write-Host "`n`nAttempting to add selected devices to ticket:`n" -ForegroundColor Green

    [Array]$Devicenames = $Null

    Foreach ($device in $devicelist)
    {
        Write-Host $device.number -NoNewline
        
        $Added = Add-COREDeviceToTicket -ticket $Global:ticketnum -device $device.number

        Write-Host $Added

        If ($Added)
        {
            Write-Host "...Added" -ForegroundColor Green
            $Devicenames = $Devicenames + $device.number
        }
        Else
        {
            Write-Host "...Error" -ForegroundColor Red
        }
        Write-Host " "
    }

If ($Devicenames -ne $Null)
{

$CoreMessage = @"
Devices add to ticket:

$Devicenames

Devices selectively added to ticket via automation script from Nucleus Extensions Menu
Wiki: https://one.rackspace.com/display/IAW/Nucleus+Extensions+Menu
"@

    Update-CoreTicket -Ticket $Ticketnum -Message $CoreMessage

    Write-Host "`n`nDevices and private update added to ticket.  Please refresh the ticket.`n" -ForegroundColor Green

}
Else
{
    Write-Host "No Devices added to ticket as none were selected in Out-GridView" -ForegroundColor Yellow
}

}
Else
{
    Write-Host "Error - No Devices returned from account" -ForegroundColor Red
}
}

<#
.Synopsis
   WindowsCertInstaller - Export certificate from CORE
.DESCRIPTION
   COpy cert from CORE to media share to import on server
#>
Function MenuNew-ExportSSLCertificate{

#Check Version of Powershell, only run on version 3 and above.
$PSVer = $psversiontable.psversion.major
If ($PSVer -lt 2)
{
    Write-Host "Powershell version $PSVer installed." -ForegroundColor red
    Break
}

    Write-Host "Loading export SSL certificate script" -ForegroundColor Yellow

$commands = "$Global:RootPath\WindowsCertInstaller\WindowsCertInstaller-CORE.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands

}

<#
.Synopsis
   CTKCore - Export ticket summary to CSV
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function Menu-TicketSummarytoCSV{

#Check Version of Powershell, only run on version 3 and above.
$PSVer = $psversiontable.psversion.major
If ($PSVer -lt 3)
{
    Write-Host "Powershell version $PSVer installed.  Powershell 3.0 required. Exiting script." -forgroundcolor Red
    Break
}

Write-Host "Loading Ticket Summary script" -ForegroundColor Yellow

Write-Host "`nListing all tickets for the last month for the account.`n"

Write-Host "Depending on the number of tickets it may take sometime to query core...`n"

Try
{
    Import-Module "$Global:RootPath\Shared_Modules\Logging_Module.psm1" -EA SilentlyContinue
    Write-MasterLogFile -functionname "CTKcore" -scriptname "TicketSummarytoCSV" -Notes "" -Account "" -Path "$Global:RootPath"
}
Catch
{
    #Do nothing
}


$commands = "import-module $Global:RootPath\CTKCore\CTKCore.psm1 -DisableNameChecking; Get-CoreTicketSummary -account $Global:accountnum;" 
$tickets = invoke-expression -command $commands
If ($tickets) 
{
    $tempFile = [io.path]::GetTempFileName()    | Rename-Item -NewName { $_ -replace 'tmp$', 'csv' } �PassThru
    $tickets | export-csv -Path $tempFile -NoTypeInformation;
           
    Write-host "`n`nCsv file has been generated here:" -ForegroundColor Green
    Write-host "$tempFile"
    Write-Host " " 
}
Else
{
    Write-Host "Error - No tickets returned from account" -ForegroundColor Red
}

}

<#
.Synopsis
   WHAM - Windows Hammertime Alternative Module
.DESCRIPTION
   Run multiple scripts on multiple servers
#>
Function MenuNew-WHAM{
$Global:RootPath
Write-Host "Loading WHAM" -ForegroundColor Yellow

$commands = "$Global:RootPath\WHAM\WHAM_Controller.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands

}

<#
.Synopsis
   Ticket Ownership - uses an export from Nucleus database to provid per-ticket ownership stats.
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function MenuNew-TicketOwnership{

Write-Host "`nTicket Ownership `n"

$commands = "$Global:RootPath\TicketOwnership\TicketOwnership.ps1 -session $Global:session -ticketnum $Global:ticketnum"
invoke-expression -command $commands
}


<#
.Synopsis
    Launch Cluster Automation Build Phase 1 (Validation)
.DESCRIPTION
    Launch Cluster Automation Build Phase 1 (Validation)
#>
Function MenuNew-CABPhase{

    $FunctionDescription = �Launch Cluster Automation Build Phase 1 (Validation)�
    Write-Host �`n`nYou have selected: $FunctionDescription`n`n� -ForegroundColor Green

    $command = "$Global:RootPath\IAW_Desktop_Scripts\RunClusterAutomaticBuildPhase1.ps1"
    Invoke-Expression $command

}

<#
.Synopsis
   BBCode - convert a csv file
.DESCRIPTION
   More detailed explanation of function. - edit as required.
#>
Function MenuNew-BBCode{

Write-Host "`nBBCode CSV conversion`n"

import-module "$Global:RootPath\BBCOde\NEW\BBCode.psm1" -force
Enter-BBCodeSession

}

<#
.Synopsis
   PoshCore Ticket Subject Search
.DESCRIPTION
   Searches for CORE tickets based on user subject
#>
Function Menu-TicketSubjectSearch {

    #Check Version of Powershell, only run on version 3 and above.
    $PSVer = $psversiontable.psversion.major
    If ($PSVer -lt 3) {
        Write-Host "Powershell version $PSVer installed.  Powershell 3.0 reqiured for Out-GridView. Exiting script." -forgroundcolor Red
        Break
    }

    Write-Host "Loading Ticket Subject Search script" -ForegroundColor Yellow
    $commands = "$Global:RootPath\poshcore\PoshCore.psm1; $Global:RootPath\TicketSubjectSearch\TicketSubjectSearch.ps1 -session $Global:session -ticketnum $Global:ticketnum"
    invoke-expression -command $commands

}

############# Menu Functions (Menu-*, MenuNew-* or MenuDisable-*) - END #############
#Any other function name will not be listed in the menu.

