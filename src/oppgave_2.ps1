[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Et navn", Mandatory = $true)]
    [string]
    $Navn
)

# Hva er forskjell mellom '' og "" som begge er streng?
#Ryddet opp
Write-Host "... Hei $Navn"