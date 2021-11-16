[CmdletBinding()]
param (
    [Int16]
    $NumberOfPasswords = 10,
    [string]
    [ValidateNotNullOrEmpty()]
    $OutputDirectory = ".\",
    [string]
    [ValidateNotNullOrEmpty()]
    $OutputFilename = "Passwörter Output.txt",
    [ValidateNotNullOrEmpty()]
    [Int16]
    $NumberOfWords = 4,
    [char]
    $Separator = "-",
    [switch]
    $AddNumber,
    [switch]
    $Force,
    [switch]
    $UseWikipedia,
    [switch]
    $ReturnList,
    [switch]
    $NoInteraction
)

if (-not $NoInteraction) {
    $NumberOfPasswords = Read-Host "Anzahl an zu generierenden Passwörtern (Standard: 10)" -as [Int16]
    $NumberOfWords = Read-Host "Anzahl Wörter pro Passwort" -as [int16]
    if (-not $NumberOfWords) {
        # Default value in case of invalid input
        $NumberOfWords = 4
    }
    $NoSelector = New-Object System.Management.Automation.Host.ChoiceDescription "&Nein", ""
    $YesSelector = New-Object System.Management.Automation.Host.ChoiceDescription "&Ja", ""
    $AddNumber = $Host.UI.PromptForChoice("Ziffer erzwingen", "Soll das Passwort eine Ziffer beinhalten", ($NoSelector, $YesSelector), 0)
}

if (-not (Test-Path $OutputDirectory -PathType Container)) {
    $OutputDirectory = ".\"
}

$OutputPath = $OutputDirectory + $OutputFilename

if ($NumberOfWords -lt 4 -and -not $Force) {
    Write-Error "Number of words can't be below 4. Setting Number to minimum." -Category InvalidData
    $NumberOfWords = 4
}

$NumberOfRuns = 0

do {
    try {
        if ($UseWikipedia) {
            $RandomWords = (Invoke-RestMethod -Uri "http://api.corpora.uni-leipzig.de/ws/words/deu_wikipedia_2010_1M/randomword/?limit=$NumberOfWords").word
        }
        else {
            $RandomWords = (Invoke-RestMethod -Uri "http://api.corpora.uni-leipzig.de/ws/words/deu_news_2012_1M/randomword/?limit=$NumberOfWords").word
        }
    }
    catch {
        Throw $_
    }

    $RawString = ""
    foreach ($Word in $RandomWords) {
        $RawString += "$Word$Separator"
    }

    if ($AddNumber -and -not ($RawString -match "[0-9]")) {
        $RawString += Get-Random -Minimum 0 -Maximum 9
    }

    $FilteredString = $RawString.TrimEnd("$Separator") -replace " ", "_" -replace "\.", ""
    $FilteredString += "`n"
    $PasswordOutput += $FilteredString
    $NumberOfRuns++
} while ($NumberOfRuns -lt $NumberOfPasswords)

if ($ReturnList) {
    return $PasswordOutput
}
else {
    $PasswordOutput | Out-File -FilePath $OutputPath
    Write-Verbose $PasswordOutput
}
