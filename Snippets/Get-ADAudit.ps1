function Get-ADAudit () {
    Param(
        ## Parameter Child Domain
        [Parameter(Mandatory = $false)]
        [ValidateSet("DFW", "HKG", "IAD", "LON", "ORD", "SYD", "GlobalRS")]
        [string]
        $ChildDomain,
        ## Parameter Account Number
        [Parameter(Mandatory = $false)]
        [int32]
        $Account
    )
    ## Module Import
    Import-Module ActiveDirectory
    ## Parameter Domain Input/Validation
    if (!($ChildDomain -eq $null)) {
        do {
            try {
                [ValidateSet("DFW", "HKG", "IAD", "LON", "ORD", "SYD","GlobalRS")]$ChildDomain = Read-Host -Prompt "Enter Domain (e.g. DFW/HKG/IAD/LON/ORD/SYD/GlobalRS)"
            } catch {}
        } until ($?)
    }
    ## Check for Intensive/GlobalRS
    if ($ChildDomain -eq "GlobalRS") {
        $Server = $ChildDomain + ".Rack.Space"
    } else {
        $Server = $ChildDomain + ".intensive.int"
    }    
    ## DNS Array
    $FullDomain = $Server.Split('.')
    foreach ($v in $FullDomain) {
        $FullDomain += "DC=" + $v
        $FullDomain = $FullDomain -ne $v
    }
    ## DNS/DN String
    $FullDomain = $FullDomain -join ","
    ## Corrects OU Structure based on City
    switch ($ChildDomain) {
        "DFW"       { $City = "OU=Rax,OU=Dallas"    }
        "HKG"       { $City = "OU=Rax,OU=HongKong"  }
        "IAD"       { $City = "OU=Rax,OU=Dulles"    }
        "LON"       { $City = "OU=Rax,OU=London"    }
        "ORD"       { $City = "OU=Rax,OU=Chicago"   }
        "SYD"       { $City = "OU=Rax,OU=Sydney"    }
        "GlobalRS"  { $City = "OU=Rax"              }
    }
    ## Parameter Account Input/Validation
    if (!($Account -eq $null)) {
        do {
            try {
                [ValidatePattern('[0-9]')]$Account = Read-Host -Prompt "Enter Account Number"
            }
            catch {}
        } until (($?) -and (Get-ADOrganizationalUnit -Server $Server -Identity "OU=$Account,$City,$FullDomain"))
    }
    ## Distinguished Name
    $DistinguishedName = "OU=" + $Account + "," + $City + "," + $FullDomain
    ## Output
    $Output = Get-ADUser -Server $Server -SearchBase $DistinguishedName -Filter * -Properties *
    $Output | Format-Table -AutoSize Name, Enabled
}
