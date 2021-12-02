[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når paramater ikke er gitt brukes default verdi
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)
 
$ErrorActionPreference = 'Stop'
$webrequest = Invoke-WebRequest -Uri $UrlKortstokk
$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]$kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)" + ","
    }
    return $streng.TrimEnd(',')
}

 Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"


function sumPoengKortstokk {
    [OutputType([int])]
    param (
        [object[]]
        $kortstokk
    )

    $poengKortstokk = 0

    foreach ($kort in $kortstokk) {
        # Undersøk hva en Switch er
        $poengKortstokk += switch ($kort.value) {
            { $kort.value -cin @('J', 'Q', 'K') } { 10 }
            'A' { 11 }
            default { $kort.value }
        }    
    }
    return $poengKortstokk
}

 Write-Output "Poengsum: $(sumPoengKortstokk -kortstokk $kortstokk)"
function skrivUtResultat {
    [OutputType([String])]
    param (      
        [object[]]$kortstokk
    )

$meg = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]
$magnus = $kortstokk[0..1]
$kortstokk = $kortstokk[2..$kortstokk.Count]

$minsum = $(sumPoengKortstokk -kortstokk $meg)
$magnussum = $(sumPoengKortstokk -kortstokk $magnus)


# bruker 'blackjack' som et begrep - er 21
$blackjack = 21

if ($minsum -eq $blackjack) {
    $vinner = "meg"
    break
}
elseif ($magnussum -eq $blackjack) {
    $vinner = "magnus"
    break
}
elseif ($minsum -eq $blackjack -and $magnussum -eq $blackjack) {
    $vinner = "draw"
    break
}
else {
    
    if ($minsum -le 21) {
         if ($minsum -le 17){
           do {
            $meg += $kortstokk[0]
            $kortstokk = $kortstokk[1..$kortstokk.Count]
            $minsum = sumPoengKortstokk -kortstokk $meg
                if ($minsum -eq 21){
                $ vinner = "Meg"
                break 
                }
                elseif ($minsum -ge 21) {
                $vinner = "Magnus"
                break
                } 

            } while ($minsum -le 16)
          }
        }
    if ($minsum -ge 17) {
            do {
                $magnus += $kortstokk[0]
                $kortstokk = $kortstokk[1..$kortstokk.Count]
                $magnussum = sumPoengKortstokk -kortstokk $magnus
                    if ($magnussum -ge 21) {
                        $vinner = "meg"
                        break
                    }
                    elseif ($magnussum -eq 21) {
                        $vinner = "magnus"
                        break              
                    }
                }while($magnussum -le $minsum)
        }   
    }
Write-Host "Vinner : $vinner"
Write-Host "Magnus : $magnussum  | $(kortstokkTilStreng -kortstokk $magnus)"
Write-Host "Meg : $minsum | $(kortstokkTilStreng -kortstokk $meg)" 
}

skrivUtResultat -kortstokk $kortstokk